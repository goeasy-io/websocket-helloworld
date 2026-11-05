package io.goeasy.helloworld

import android.content.Intent
import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.view.View
import android.widget.EditText
import android.widget.TextView
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch

/**
 * GoEasy WebSocket 示例。
 *
 * 连接、订阅、收发消息的逻辑在 ChatViewModel 里，这里只负责把状态显示到界面。
 */
class MainActivity : AppCompatActivity(), View.OnClickListener {

    private val viewModel: MainViewModel by viewModels()
    private lateinit var messages: TextView
    private lateinit var input: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        input = findViewById(R.id.message)
        messages = findViewById(R.id.message_list)
        messages.movementMethod = ScrollingMovementMethod()
        findViewById<TextView>(R.id.button).setOnClickListener(this)

        lifecycleScope.launch {
            viewModel.messages.collect { messages.text = it }
        }

        showNotificationMessage(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        showNotificationMessage(intent)
    }

    override fun onClick(v: View?) {
        if (v?.id == R.id.button) {
            viewModel.send(input.text.toString())
            input.setText("")
        }
    }

    /** 展示通知栏点进来的消息 */
    private fun showNotificationMessage(intent: Intent) {
        val content = intent.getStringExtra(EXTRA_MESSAGE) ?: return
        intent.removeExtra(EXTRA_MESSAGE)
        viewModel.onNotificationMessage(content)
    }

    companion object {
        const val EXTRA_MESSAGE = "message"
    }
}
