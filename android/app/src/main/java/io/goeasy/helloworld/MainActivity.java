package io.goeasy.helloworld;

import static io.goeasy.helloworld.GoEasyConfig.appkey;
import static io.goeasy.helloworld.GoEasyConfig.host;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.text.SimpleDateFormat;
import java.util.Date;

import io.goeasy.ConnectEventListener;
import io.goeasy.ConnectOptions;
import io.goeasy.GResult;
import io.goeasy.GoEasy;
import io.goeasy.GoEasyEventListener;
import io.goeasy.pubsub.GPubSub;
import io.goeasy.pubsub.PubSubMessage;
import io.goeasy.pubsub.SubscribeEventListener;

public class MainActivity extends AppCompatActivity {
    private TextView messages;
    private EditText input;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView button = findViewById(R.id.button);
        button.setOnClickListener(this::onClick);

        input = findViewById(R.id.message);
        messages = findViewById(R.id.message_list);
        if (messages != null) {
            messages.setMovementMethod(new ScrollingMovementMethod());
        }

        // 初始化 GoEasy
        GoEasy.init(host, appkey, this.getApplicationContext());
        // 连接 GoEasy
        connectGoEasy();
        // 接收消息
        subscribe();
    }

    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.button:
                String content = input.getText().toString();
                GPubSub.publish("test_channel", content, new GoEasyEventListener() {

                    @Override
                    public void onSuccess(GResult gResult) {
                        Log.i("Android Hello World", gResult.getData().toString());
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                if (input != null) {
                                    input.setText("");
                                }
                            }
                        });
                    }

                    @Override
                    public void onFailed(GResult error) {
                        unshiftMessage("消息发送失败，错误编码：" + error.getCode() + " 错误信息：" + error.getData());
                    }
                });
                break;
        }
    }



    private void connectGoEasy() {
        GoEasy.connect(new ConnectEventListener() {

            @Override
            public void onSuccess(GResult data) {
                unshiftMessage("连接成功");
            }

            @Override
            public void onFailed(GResult error) {
                unshiftMessage("Failed to connect GoEasy, code:" + error.getCode() + ",error:" + error.getData());
            }

            @Override
            public void onProgress(int attempts) {
                Log.i("Android Hello World", "GoEasy connect progress attempts: " + attempts);
            }
        });
    }

    private void subscribe() {
        GPubSub.subscribe("test_channel", new SubscribeEventListener() {

            @Override
            public void onMessage(PubSubMessage message) {
                unshiftMessage(message.getContent());
            }

            @Override
            public void onSuccess(GResult data) {
                unshiftMessage("订阅成功");
            }

            @Override
            public void onFailed(GResult error) {
                unshiftMessage("订阅失败，错误编码：" + error.getCode() + " 错误信息：" + error.getData());
            }
        });
    }


    @SuppressLint({"SimpleDateFormat", "SetTextI18n"})
    private void unshiftMessage(String message) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm");
                String date = simpleDateFormat.format(new Date());

                String newMessage = date + " " + message + "\n";
                CharSequence originalContent = messages != null ? messages.getText() : null;
                if (messages != null) {
                    messages.setText(newMessage + originalContent);
                }
            }
        });
    }


}