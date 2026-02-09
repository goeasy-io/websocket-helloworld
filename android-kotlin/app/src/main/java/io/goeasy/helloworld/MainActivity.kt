package io.goeasy.helloworld

import android.Manifest
import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.util.Log
import android.view.View
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import io.goeasy.helloworld.GoEasyConfig.appkey
import io.goeasy.helloworld.GoEasyConfig.host
import io.goeasy.sdk.GoEasy
import io.goeasy.sdk.types.common.ConnectOptions
import io.goeasy.sdk.types.common.InitOptions
import io.goeasy.sdk.types.pubsub.SubscribeOptions
import io.goeasy.sdk.types.pubsub.PublishOptions
import io.goeasy.sdk.types.common.NotificationOptions
import io.goeasy.sdk.types.common.GResult
import io.goeasy.sdk.types.common.HarmonyOptions
import io.goeasy.sdk.types.common.HonorOptions
import io.goeasy.sdk.types.common.HuaweiOptions
import io.goeasy.sdk.types.common.OppoOptions
import io.goeasy.sdk.types.common.VendorOptions
import io.goeasy.sdk.types.common.VivoOptions
import io.goeasy.sdk.types.common.XiaomiOptions
import io.goeasy.sdk.types.pubsub.PubSubMessage
import java.text.SimpleDateFormat
import java.util.*


class MainActivity : AppCompatActivity(), View.OnClickListener {
    private var messages: TextView? = null
    private var input: EditText? = null
    private var TAG: String = "demo"


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val button = findViewById<TextView>(R.id.button)
        button.setOnClickListener(this)

        input = findViewById(R.id.message)
        messages = findViewById(R.id.message_list)
        messages?.movementMethod = ScrollingMovementMethod()


        //请求推送权限
        requestNotificationPermission()

        //初始化GoEasy
        initGoEasy()
        //连接GoEasy
        connectGoEasy()
        //接收消息
        subscribe()

    }

    override fun onClick(v: View?) {
        when(v?.id){
            R.id.button -> {
                val content = input?.text.toString()
                sendMessage(content)
                input?.text = null
            }
        }
    }
    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // 检查是否已有权限
            val granted = ActivityCompat.checkSelfPermission(this,Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
            if (!granted) {
                ActivityCompat.requestPermissions( this, arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1001)
            }
        }
    }

    private fun initGoEasy() {
        val options = InitOptions(host, appkey, modules= listOf("pubsub"), allowNotification = true)
        GoEasy.init(this, options)
    }

    private fun connectGoEasy() {
        val connectOptions = ConnectOptions(
            id = "001",
            data = mapOf("nickname" to "001", "avatarId" to "001"),
            onSuccess = {
                Log.i(TAG,"连接成功")
                unshiftMessage("连接成功")
            },
            onProgress = { attempts: Int ->
                Log.i(TAG, "onProgress attempts: $attempts")
            },
            onFailed =  { error: GResult<*> ->
                Log.i(TAG,"连接失败, code:" + error.code + ",error:" + error.data);
                unshiftMessage("Failed to connect GoEasy, code:" + error.code + ",error:" + error.data);
            }
        )
        GoEasy.connect(connectOptions)
    }

    private fun subscribe() {
        GoEasy.pubsub.subscribe(SubscribeOptions(
            channel = "my_channel",
            onMessage = { message: PubSubMessage ->
                Log.i(TAG,"Message content: ${message.content}")
                unshiftMessage(message.content)
            },
            onSuccess = {
                Log.i(TAG,"订阅成功")
                unshiftMessage("订阅成功")
            },
            onFailed = { error ->
                Log.i(TAG,"订阅失败， code: ${error.code} data: ${error.data}")
                unshiftMessage("订阅失败，错误编码：" + error.code + " 错误信息：" + error.data);
            }
        ))
    }

    private fun sendMessage(message: String) {
        GoEasy.pubsub.publish(PublishOptions(
            channel = "my_channel",
            message = message,
            qos = 1,
            notification = NotificationOptions(
                title = "您有一条消息",
                body = message,
                sound = "message",
                badge = "+1",
                vendorOptions = VendorOptions(
                    huawei = HuaweiOptions(
                        category = "EXPRESS"
                    ),
                    oppo = OppoOptions(
                        channel_id = "order_channel"
                    ),
                    xiaomi = XiaomiOptions(
                        channel_id = "110828"
                    ),
                    vivo = VivoOptions(
                        classification = 1,
                        category = "ORDER"
                    ),
                    honor = HonorOptions(
                        importance = "NORMAL"
                    ),
                    harmony = HarmonyOptions(
                        category = "IM"
                    ),
                )
            ),
            onSuccess = {
                Log.i(TAG, "消息发送成功")
            },
            onFailed = {error: GResult<*> ->
                Log.i(TAG,"发送失败，code：" + error.code + " data：" + error.data);
                unshiftMessage("消息发送失败，错误编码：" + error.code + " 错误信息：" + error.data);
            }
        ))
    }

    @SuppressLint("SimpleDateFormat", "SetTextI18n")
    private fun unshiftMessage(message: String) {
        runOnUiThread {
            val simpleDateFormat = SimpleDateFormat("HH:mm")
            val date = simpleDateFormat.format(Date())

            val newMessage = "$date $message\n"
            val originalContent = messages?.text
            messages!!.text = "$newMessage$originalContent"

            input?.setText("")
        }
    }

}

