<template>
    <view class="content">
        <view class="header">
            <view class="title">GoEasy示例</view>
            <view class="description">Hello world</view>
        </view>
        <view class="send-box">
            <input v-model="message"/>
            <text @click="sendMessage">发送</text>
        </view>
        <view class="message-content">
            <view class="message-text" v-for="(msg, index) in messages" :key="index">{{ msg }}</view>
        </view>
    </view>
</template>

<script setup>
import {ref, inject} from 'vue'
import {onLoad} from "@dcloudio/uni-app";
const goEasy = inject('goEasy');

let message = ref('')
let messages = ref([])

onLoad(() => {
    connectGoEasy();
});

function connectGoEasy () {
    goEasy.connect({
        onSuccess: () => {
            console.log("GoEasy connect successfully.")
            subscribe()
        },
        onFailed: (error) =>  {
            console.log("Failed to connect GoEasy, code:" + error.code + ",error:" + error.content);
            uni.showModal({
                title: error.code.toString(),
                content: error.content,
                showCancel: false,
                duration: 6000
            })
        },
        onProgress: (attempts) =>  {
            console.log("GoEasy is connecting", attempts);
        }
    });
}

function subscribe () {
    goEasy.pubsub.subscribe({
        channel: "my_channel",
        onMessage: (message) =>  {
            unshiftMessage(message.content)
        },
        onSuccess: () =>  {
            unshiftMessage("订阅成功")
        },
        onFailed: (error) =>  {
            unshiftMessage("订阅失败，错误编码：" + error.code + " 错误信息：" + error.content);
        }
    });
}

function sendMessage () {
    if (message.value.trim() != "") {
        let body = message.value;
        if (message.value.length >= 50) {
            body = message.value.substring(0, 30) + "...";
        }
        goEasy.pubsub.publish({
            channel: "my_channel",
            message: message.value,
            //只要接收端APP参数以及GoEasy控制台参数正确配置，并且allowNotification为true，就可以接收通知栏提醒
            //若不需要通知栏提醒，可以直接删掉notification
            notification: {
                title: "收到一条新消息",
                body: body      // 字段最长50字符
            },
            onSuccess: () =>  {
                message.value = ''; //清空发送消息内容
            },
            onFailed: (error) =>  {
                unshiftMessage("消息发送失败，错误编码：" + error.code + " 错误信息：" + error.content);
            }
        });
    }
}

function unshiftMessage (content) {
    const formattedTime = formatDate(new Date(), "hh:mm");
    const message = formattedTime + " " + content;
    messages.value.unshift(message);
}

function formatDate(date, format) {
    const o = {
        "M+": date.getMonth() + 1,
        "d+": date.getDate(),
        "h+": date.getHours(),
        "m+": date.getMinutes(),
        "s+": date.getSeconds(),
        "q+": Math.floor((date.getMonth() + 3) / 3),
        "S": date.getMilliseconds()
    };
    if (/(y+)/.test(format))
        format = format.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (let k in o)
        if (o.hasOwnProperty(k)) {
            if (new RegExp("(" + k + ")").test(format))
                format = format.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        }
    return format;
}

</script>

<style>
.content {
    padding: 20px 20px 0 20px;
    font-family: Source Han Sans CN;
    width: 100%;
    height: 100%;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.header {
    display: flex;
    flex-direction: column;
    align-items: center;
    color: #D02129;
    margin-top: 50px;
}

.header .title {
    height: 25px;
    line-height: 25px;
    font-size: 24px;
}

.header .description {
    height: 25px;
    line-height: 25px;
    font-size: 28px;
    font-weight: bold;
    margin-top: 10px;
}

.send-box {
    display: flex;
    flex-direction: row;
    height: 40px;
    margin-top: 32px;
    margin-bottom: 32px;
}

.send-box input {
    flex-grow: 1;
    background: #EFEFEF;
    border: 1px solid #C8C7CC;
    border-radius: 6px;
    padding: 8px;
}

.send-box text {
    color: #D02129;
    margin-left: 9px;
    font-size: 15px;
    height: 40px;
    line-height: 40px;
    width: 40px;
    text-align: right;
}

.message-content {
    min-height: 300px;
    background: #FFFFFF;
    border: 1px solid #DADADA;
    margin-top: 26px;
}

.message-text {
    padding: 4px 11px;
}
</style>
