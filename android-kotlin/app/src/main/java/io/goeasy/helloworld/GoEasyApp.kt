package io.goeasy.helloworld

import android.app.Application
import android.util.Log
import io.goeasy.GoEasy

/**
 * 初始化 GoEasy，并接管通知栏点击。
 */
class GoEasyApp : Application() {

    override fun onCreate() {
        super.onCreate()

        GoEasy.init(
            host = "hangzhou.goeasy.io",
            appkey = "BC-xxxx",
            notification = true,
            context = applicationContext
        )

        GoEasy.notification.onClick { data ->
            Log.i("GoEasy","点击通知栏：${data}")
        }
    }
}
