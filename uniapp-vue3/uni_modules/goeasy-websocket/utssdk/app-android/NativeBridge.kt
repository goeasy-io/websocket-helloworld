package uts.sdk.modules.goeasyWebsocket

import android.app.Activity
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.goeasy.sdk.GoEasy
import io.goeasy.GN
import io.goeasy.GoEasyListener
import io.goeasy.sdk.types.common.ConnectOptions
import io.goeasy.sdk.types.common.InitOptions
import io.goeasy.sdk.types.pubsub.SubscribeOptions
import io.goeasy.sdk.types.pubsub.PubSubMessage
import io.goeasy.sdk.types.pubsub.PublishOptions
import io.goeasy.sdk.types.common.NotificationOptions
import io.goeasy.sdk.types.common.VendorOptions
import io.goeasy.sdk.types.common.HuaweiOptions
import io.goeasy.sdk.types.common.XiaomiOptions
import io.goeasy.sdk.types.common.OppoOptions
import io.goeasy.sdk.types.common.VivoOptions
import io.goeasy.sdk.types.common.HarmonyOptions
import io.goeasy.sdk.types.common.GResult
import io.goeasy.sdk.types.common.DisConnectOptions
import io.goeasy.sdk.types.pubsub.UnSubscribeOptions
import io.goeasy.sdk.types.pubsub.HistoryOptions
import java.lang.ref.WeakReference
import org.json.JSONObject
import org.json.JSONArray


/**
 * 原生桥接层
 * 封装 GoEasy Android SDK 的原生调用，提供给 UTS 层使用
 */
object NativeBridge {
    private var activityRef: WeakReference<Activity>? = null
    private const val TAG = "NativeBridge"

    private fun runOnUiThread(activity: Activity, block: () -> Unit) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            block()
            return
        }
        // Avoid touching View/WebView on non-UI threads
        Handler(Looper.getMainLooper()).post {
            try {
                if (activity.isFinishing || activity.isDestroyed) {
                    Log.w(TAG, "Skip UI task: activity is finishing/destroyed")
                    return@post
                }
                block()
            } catch (e: Exception) {
                Log.e(TAG, "UI task failed", e)
            }
        }
    }

    private fun Any?.toStringAnyMap(): Map<String, Any?>? {
        val m = this as? Map<*, *> ?: return null
        val out = LinkedHashMap<String, Any?>(m.size)
        for ((k, v) in m) {
            if (k is String) out[k] = v
        }
        return out
    }

    fun register(activity: Activity, successCallBack: (String) -> Unit, failCallBack: (String) -> Unit) {
        activityRef = WeakReference<Activity>(activity)
        runOnUiThread(activity) {
            GN.register(activity, object : GoEasyListener {
                override fun onRegisterSuccess(regId: String?) {
                    successCallBack.invoke(regId ?: "")
                }

                override fun onRegisterFailed(code: Int, errorMsg: String?) {
                    failCallBack.invoke(errorMsg ?: "")
                }
            })
        }
    }

    fun init(activity: Activity, host: String, appkey: String, modules: List<String>, allowNotification: Boolean?) {
        activityRef = WeakReference(activity)
        val options = InitOptions(host, appkey, modules, allowNotification = allowNotification)
        runOnUiThread(activity) {
            GoEasy.init(activity, options)
            Log.d(TAG, "GoEasy initialized successfully")
        }
    }

    fun connect(
        id: String?,
        data: Map<String, String>?,
        otp: String?,
        onSuccess: () -> Unit,
        onFailed: (Int, String?) -> Unit,
        onProgress: ((Int) -> Unit)?
    ) {
        try {
            val connectOptions = ConnectOptions(
                onSuccess = {
                    Log.i(TAG, "连接成功")
                    onSuccess.invoke()
                },
                onProgress = { attempts: Int ->
                    Log.i(TAG, "onProgress attempts: $attempts")
                    onProgress?.invoke(attempts)
                },
                onFailed = { error: GResult<*> ->
                    val code = try {
                        val method = error.javaClass.getMethod("getCode")
                        method.invoke(error) as? Int ?: 408
                    } catch (e: Exception) {
                        try {
                            error.javaClass.getDeclaredField("code").apply { isAccessible = true }.get(error) as? Int ?: -1
                        } catch (e2: Exception) {
                            Log.e(TAG, "Failed to get code from GResult", e2)
                            408
                        }
                    }

                    val errorData = try {
                        val method = error.javaClass.getMethod("getData")
                        method.invoke(error)?.toString() ?: ""
                    } catch (e: Exception) {
                        try {
                            error.javaClass.getDeclaredField("data").apply { isAccessible = true }.get(error)?.toString() ?: ""
                        } catch (e2: Exception) {
                            Log.e(TAG, "Failed to get data from GResult", e2)
                            ""
                        }
                    }

                    Log.i(TAG, "连接失败, code:$code, error:$errorData")
                    onFailed.invoke(code, errorData)
                }
            )
            GoEasy.connect(connectOptions)
        } catch (e: Exception) {
            Log.e(TAG, "GoEasy connect failed", e)
            onFailed.invoke(-1, e.message)
        }
    }

    /**
     * 断开连接
     */
    fun disconnect(
        onSuccess: () -> Unit,
        onFailed: (Int, String?) -> Unit
    ) {
        val options = DisConnectOptions(
            onSuccess = {
                Log.i(TAG, "断开连接成功")
                onSuccess.invoke()
            },
            onFailed = { error ->
                val code = try {
                    val method = error.javaClass.getMethod("getCode")
                    method.invoke(error) as? Int ?: -1
                } catch (e: Exception) {
                    -1
                }
                val errorData = try {
                    val method = error.javaClass.getMethod("getData")
                    method.invoke(error)?.toString() ?: ""
                } catch (e: Exception) {
                    ""
                }
                Log.i(TAG, "断开连接失败, code:$code, error:$errorData")
                onFailed.invoke(code, errorData)
            }
        )
        GoEasy.disconnect(options)
    }

    /**
     * 取消订阅
     */
    fun unsubscribe(
        channel: String,
        onSuccess: () -> Unit,
        onFailed: (Int, String?) -> Unit
    ) {
        val options = UnSubscribeOptions(
            channel = channel,
            onSuccess = {
                Log.i(TAG, "取消订阅成功")
                onSuccess.invoke()
            },
            onFailed = { error ->
                Log.i(TAG, "取消订阅失败, code:${error.code}, error:${error.data}")
                onFailed.invoke(error.code, error.data?.toString())
            }
        )
        GoEasy.pubsub.unsubscribe(options)
    }

    /**
     * 查询历史消息
     */
    fun history(
        channel: String,
        start: Long?,
        end: Long?,
        limit: Int?,
        onSuccess: (Any) -> Unit,
        onFailed: (Int, String?) -> Unit
    ) {
        val options = HistoryOptions(
            channel = channel,
            start = start,
            end = end,
            limit = limit,
            onSuccess = { messages ->
                Log.i(TAG, "查询历史消息成功, size: ${messages.size}")
                val root = JSONObject()
                root.put("code", 200)
                val contentObj = JSONObject()
                val jsonArray = JSONArray()
                messages.forEach { msg ->
                    val m = JSONObject()
                    m.put("time", msg.time)
                    m.put("content", msg.content)
                    jsonArray.put(m)
                }
                contentObj.put("messages", jsonArray)
                root.put("content", contentObj)
                onSuccess.invoke(root.toString())
            },
            onFailed = { error ->
                Log.i(TAG, "查询历史消息失败, code:${error.code}, error:${error.data}")
                onFailed.invoke(error.code, error.data?.toString())
            }
        )
        GoEasy.pubsub.history(options)
    }

    fun subscribe(
        channel: String,
        onMessage: (String, String) -> Unit,
        onSuccess: () -> Unit,
        onFailed: (Int, String?) -> Unit
    ) {
        val subscribeOptions = SubscribeOptions(
            channel = channel,
            onMessage = { message: PubSubMessage ->
                onMessage.invoke(message.channel, message.content)
            },
            onSuccess = {
                Log.i(TAG, "订阅成功")
                onSuccess.invoke()
            },
            onFailed = { error ->
                Log.i(TAG, "订阅失败， code: ${error.code} data: ${error.data}")
                onFailed.invoke(error.code, error.data?.toString())
            }
        )
        GoEasy.pubsub.subscribe(subscribeOptions)
    }

    fun publish(
        channel: String,
        message: String,
        qos: Int?,
        notification: Map<String, Any>?,
        onSuccess: () -> Unit,
        onFailed: (Int, String?) -> Unit
    ) {
        val notificationOptions = notification?.let { n ->
            val vMap = n["vendorOptions"].toStringAnyMap()
            val vendorOptions = vMap?.let { v ->
                io.goeasy.sdk.types.common.VendorOptions(
                    huawei = v["huawei"].toStringAnyMap()?.let {
                        io.goeasy.sdk.types.common.HuaweiOptions(category = it["category"] as? String ?: "")
                    },
                    xiaomi = v["xiaomi"].toStringAnyMap()?.let {
                        io.goeasy.sdk.types.common.XiaomiOptions(channel_id = it["channel_id"]?.toString() ?: "")
                    },
                    oppo = v["oppo"].toStringAnyMap()?.let {
                        io.goeasy.sdk.types.common.OppoOptions(channel_id = it["channel_id"] as? String ?: "")
                    },
                    vivo = v["vivo"].toStringAnyMap()?.let {
                        io.goeasy.sdk.types.common.VivoOptions(
                            classification = (it["classification"] as? Number)?.toInt() ?: 0,
                            category = it["category"] as? String ?: ""
                        )
                    },
                    harmony = v["harmony"].toStringAnyMap()?.let {
                        io.goeasy.sdk.types.common.HarmonyOptions(category = it["category"] as? String ?: "")
                    }
                )
            }

            io.goeasy.sdk.types.common.NotificationOptions(
                title = n["title"] as? String ?: "",
                body = n["body"] as? String ?: "",
                sound = n["sound"] as? String,
                badge = n["badge"] as? String,
                vendorOptions = vendorOptions
            )
        }

        val publishOptions = PublishOptions(
            channel = channel,
            message = message,
            qos = qos,
            notification = notificationOptions,
            onSuccess = {
                Log.i(TAG, "消息发送成功")
                onSuccess.invoke()
            },
            onFailed = { error: GResult<*> ->
                Log.i(TAG, "发送失败，code：${error.code} data：${error.data}")
                onFailed.invoke(error.code, error.data?.toString())
            }
        )
        GoEasy.pubsub.publish(publishOptions)
    }

}

