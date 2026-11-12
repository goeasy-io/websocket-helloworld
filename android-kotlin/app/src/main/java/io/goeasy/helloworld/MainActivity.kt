package io.goeasy.helloworld

import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.util.Log
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import io.goeasy.GoEasy
import io.goeasy.notification.NotificationOptions
import io.goeasy.runtime.GoEasyException
import io.goeasy.ws.PublishOptions
import java.text.SimpleDateFormat
import java.util.Date
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {

    private lateinit var messages: TextView
    private lateinit var input: EditText

    private val lines = ArrayDeque<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        input = findViewById(R.id.message)
        messages = findViewById(R.id.message_list)
        messages.movementMethod = ScrollingMovementMethod()

        findViewById<TextView>(R.id.button).setOnClickListener {
            publish(input.text.toString())
        }

        GoEasy.onStateChange { event ->
            append("当前状态: ${event.current}, 尝试: ${event.attempts}次")
        }


        /**
        * todo:
        * 若需接收通知提醒，需在应用设置中开启通知权限，或在连接 GoEasy 之前通过代码获取权限。
        * 即使没有通知权限也不影响 WebSocket 消息收发，仅影响通知提醒
        **/
        lifecycleScope.launch {
            try {
                GoEasy.connect()
                append("连接成功")
                GoEasy.ws.subscribe(listOf("demo_channel")) { message ->
                    // ③ 收到消
                    append(message.content)
                }
                append("订阅成功")
            } catch (e: GoEasyException) {
                append("连接或订阅失败：[${e.code}] ${e.message}")
            }
        }
    }

    // ---------- 发送消息（发到同一频道，用于自测接收） ----------
    private fun publish(content: String) {
        val options = PublishOptions(
            channel = "demo_channel",
            content = content,
            notification = NotificationOptions(
                title = "GoEasy推送",
                body = "您有一条新的消息",
            )
        )
        lifecycleScope.launch {
            try {
                GoEasy.ws.publish(options)
                Log.i("GoEasy", "发送成功: $content")
                input.setText("")
            } catch (e: GoEasyException) {
                append("发送失败：[${e.code}] ${e.message}")
            }
        }
    }

    private fun append(message: String) {
        val text = SimpleDateFormat("HH:mm:ss").format(Date()) + " " + message
        runOnUiThread {
            lines.addFirst(text)
            while (lines.size > 100) {
                lines.removeLast()
            }
            messages.text = lines.joinToString("\n")
        }
    }
}