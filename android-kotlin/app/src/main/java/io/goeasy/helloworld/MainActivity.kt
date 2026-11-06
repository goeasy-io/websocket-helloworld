package io.goeasy.helloworld

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.widget.EditText
import android.widget.TextView
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch

/**
 * GoEasy WebSocket 示例。
 *
 * 连接、订阅、收发消息的逻辑在 MainViewModel 里，这里只负责把状态显示到界面。
 */
class MainActivity : AppCompatActivity() {

    private val viewModel: MainViewModel by viewModels()
    private lateinit var messages: TextView
    private lateinit var input: EditText

    /** Android 13+ 需要运行时请求通知权限，收到结果后无论允许/拒绝都继续连接 */
    private val notificationPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { viewModel.start() }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        input = findViewById(R.id.message)
        messages = findViewById(R.id.message_list)
        messages.movementMethod = ScrollingMovementMethod()
        findViewById<TextView>(R.id.button).setOnClickListener {
            viewModel.send(input.text.toString())
            input.setText("")
        }

        lifecycleScope.launch {
            viewModel.messages.collect { messages.text = it }
        }

        checkNotificationPermissionAndStart()
    }

    /** 只针对 Android 13+ 请求通知权限，老版本直接连接 */
    private fun checkNotificationPermissionAndStart() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS)
            != PackageManager.PERMISSION_GRANTED
        ) {
            notificationPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
        } else {
            viewModel.start()
        }
    }
}
