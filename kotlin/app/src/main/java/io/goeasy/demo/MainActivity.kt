package io.goeasy.demo

import android.annotation.SuppressLint
import android.os.Bundle
import android.text.method.ScrollingMovementMethod
import android.util.Log
import android.view.View
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import io.goeasy.*
import io.goeasy.pubsub.GPubSub
import io.goeasy.pubsub.PubSubMessage
import io.goeasy.pubsub.SubscribeEventListener
import java.text.SimpleDateFormat
import java.util.*


class MainActivity : AppCompatActivity(), View.OnClickListener {
    private var messages: TextView? = null
    private var input: EditText? = null


    @SuppressLint("RtlHardcoded")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val button = findViewById<TextView>(R.id.button)
        button.setOnClickListener(this)

        input = findViewById(R.id.message)
        messages = findViewById(R.id.message_list)
        messages?.movementMethod = ScrollingMovementMethod()

        //初始化GoEasy
        initGoEasy()
        //连接GoEasy
        connectGoEasy()
        //接收消息
        subscribe()

    }

    @SuppressLint("SimpleDateFormat", "SetTextI18n")
    override fun onClick(v: View?) {
        when(v?.id){
            R.id.button -> {
                val content = input?.text.toString()
                sendMessage(content)
            }
        }
    }

    private fun initGoEasy() {
        val host = "hangzhou.goeasy.io" //应用所在的区域地址: 【hangzhou.goeasy.io |singapore.goeasy.io】
        val appkey = "BC-xxxx" // common key
        GoEasy.init(host, appkey, this.applicationContext)
    }

    private fun connectGoEasy() {
        val connectOptions = ConnectOptions()
        GoEasy.connect(connectOptions, object : ConnectEventListener() {
            override fun onSuccess(data: GResult<*>?) {
                unshiftMessage("连接成功")
            }

            override fun onFailed(error: GResult<*>) {
                unshiftMessage("Failed to connect GoEasy, code:" + error.code + ",error:" + error.data);
            }

            override fun onProgress(attempts: Int) {
                Log.i("Kotlin Hello World", "GoEasy connect progress attempts: $attempts")
            }
        })
    }

    private fun subscribe() {
        GPubSub.subscribe("test_channel", object : SubscribeEventListener() {
            override fun onMessage(message: PubSubMessage) {
                unshiftMessage(message.content)
            }

            override fun onSuccess(data: GResult<*>?) {
                unshiftMessage("订阅成功")
            }

            override fun onFailed(error: GResult<*>) {
                unshiftMessage("订阅失败，错误编码：" + error.code + " 错误信息：" + error.data);
            }
        })
    }

    private fun sendMessage(message: String) {
        GPubSub.publish("test_channel", message, object : GoEasyEventListener() {
            override fun onSuccess(data: GResult<*>) {
                Log.i("Kotlin Hello World", data.data as String)
            }
            override fun onFailed(error: GResult<*>) {
                unshiftMessage("消息发送失败，错误编码：" + error.code + " 错误信息：" + error.data);
            }
        })
    }

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

