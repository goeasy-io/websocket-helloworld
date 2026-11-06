package io.goeasy.helloworld

import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.util.Log
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import io.goeasy.GoEasy
import io.goeasy.notification.NotificationOptions
import io.goeasy.ws.PublishOptions
import java.text.SimpleDateFormat
import java.util.Date

/**
 * GoEasy 实时消息 Demo，三步看懂核心用法：
 *
 * ① 建立连接 —— GoEasy.connect
 * ② 订阅频道 —— GoEasy.ws.subscribe
 * ③ 接收消息 —— subscribe 的 message 回调
 *
 * appkey 等初始化配置在 GoEasyApp 里，其余代码都是为上面三步服务的 UI。
 */
class MainActivity : AppCompatActivity() {

    private lateinit var messages: TextView
    private lateinit var input: EditText

    /** 消息按接收顺序存放，最多保留 100 条，避免内存越滚越大 */
    private val lines = ArrayDeque<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        input = findViewById(R.id.message)
        messages = findViewById(R.id.message_list)
        messages.movementMethod = ScrollingMovementMethod()
        findViewById<TextView>(R.id.button).setOnClickListener {
            publish(input.text.toString())
            input.setText("")
        }

        GoEasy.onStateChange { event ->
            append("当前状态: ${event.current}, 尝试: ${event.attempts}次")
        }

        // 若需接收通知提醒，需在应用设置中开启通知权限，或在连接 GoEasy 之前通过代码获取权限。
        // 即使没有通知权限也不影响 WebSocket 消息收发，仅影响通知提醒。
        // ---------- ① 建立连接 ----------
        GoEasy.connect { result ->
            if (result.isSuccess) {
                append("连接成功")
            } else {
                append("连接失败：${result.error?.let { "[${it.code}] ${it.message}" }}")
            }
        }

        // ---------- ② 订阅频道 ③ 接收消息 ----------
        GoEasy.ws.subscribe(
            listOf("demo_channel"),
            { message ->
                // ③ 收到消息，可在此打断点调试
                append("收到消息: ${message.content}")
            }
        ) { result ->
            if (result.isSuccess) {
                append("订阅成功")
            } else {
                append("订阅失败：${result.error?.let { "[${it.code}] ${it.message}" }}")
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
        GoEasy.ws.publish(options) { result ->
            if (result.isSuccess) {
                // 发送成功后自己会在 demo_channel 上收到回读，这里只打日志即可
                Log.i("GoEasy", "发送成功: $content")
            } else {
                append("发送失败：${result.error?.let { "[${it.code}] ${it.message}" }}")
            }
        }
    }

    /** 新消息追加到列表顶部；超过 100 条时丢掉最旧的（统一在主线程更新，避免跨线程） */
    private fun append(message: String) {
        val text = SimpleDateFormat("HH:mm").format(Date()) + " " + message
        runOnUiThread {
            lines.addFirst(text)
            while (lines.size > 100) {
                lines.removeLast()
            }
            messages.text = lines.joinToString("\n")
        }
    }
}