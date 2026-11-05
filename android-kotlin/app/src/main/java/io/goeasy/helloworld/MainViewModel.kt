package io.goeasy.helloworld

import androidx.lifecycle.ViewModel
import io.goeasy.GoEasy
import io.goeasy.ws.PublishOptions
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.text.SimpleDateFormat
import java.util.Date

/**
 * 持有连接与消息状态，Activity 重建（旋转屏幕）时不会断开重连、也不会重复订阅。
 */
class MainViewModel : ViewModel() {

    private val _messages = MutableStateFlow("")
    val messages: StateFlow<String> = _messages.asStateFlow()

    /** 消息按接收顺序存放，最新的在最前面 */
    private val lines = ArrayDeque<String>()

    init {
        val state =  GoEasy.state;
        append("当前连接状态: $state")
        GoEasy.onStateChange { event ->
            append("当前状态: ${event.current}, 尝试连接次数: ${event.attempts}, 错误: ${event.error?.let { "[${it.code}] ${it.message}" } ?: "无"}")
        }
        connectGoEasy()
        subscribe()
    }

    fun send(content: String) {
        if (content.isBlank()) return

        val options = PublishOptions(channel = "test_mychannel", content = content)
        GoEasy.ws.publish(options) { result ->
            if (result.isSuccess) {
                append("发送成功: $content")
            } else {
                append("消息发送失败，错误编码：" + result.error?.code + " 错误信息：" + result.error?.message)
            }
        }
    }

    /** 通知栏点进来的消息 */
    fun onNotificationMessage(content: String) {
        append("点击通知: $content")
    }

    private fun connectGoEasy() {
        GoEasy.connect { result ->
            if (result.isSuccess) {
                append("连接成功")
            } else {
                append("连接失败，错误编码：" + result.error?.code + " 错误信息：" + result.error?.message)
            }
        }
    }

    private fun subscribe() {
        GoEasy.ws.subscribe(
            listOf("test_mychannel"),
            { message -> append(message.content) }
        ) { result ->
            if (result.isSuccess) {
                append("订阅成功")
            } else {
                append("订阅失败，错误编码：" + result.error?.code + " 错误信息：" + result.error?.message)
            }
        }
    }

    /** 新消息显示在最上面，最多保留最近 100 条 */
    private fun append(message: String) {
        val time = SimpleDateFormat("HH:mm").format(Date())
        lines.addFirst("$time $message")
        while (lines.size > MAX_MESSAGES) {
            lines.removeLast()
        }
        _messages.value = lines.joinToString("\n") + "\n"
    }

    companion object {
        /** 最多保留的消息条数 */
        private const val MAX_MESSAGES = 100
    }
}
