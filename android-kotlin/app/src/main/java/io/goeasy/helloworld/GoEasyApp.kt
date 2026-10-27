package io.goeasy.helloworld

import android.app.Application
import android.content.Intent
import io.goeasy.GoEasy
import org.json.JSONObject

/**
 * 初始化 GoEasy，并接管通知栏点击。
 */
class GoEasyApp : Application() {

    override fun onCreate() {
        super.onCreate()

        GoEasy.init(
            host = GoEasyConfig.host,
            appkey = GoEasyConfig.appkey,
            notification = true,
            context = applicationContext
        )

        GoEasy.notification.onClick { data ->
            val content = runCatching { JSONObject(data).optString("content") }.getOrDefault(data)
            startActivity(
                Intent(this, MainActivity::class.java).apply {
                    putExtra(MainActivity.EXTRA_MESSAGE, content)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                }
            )
        }
    }
}
