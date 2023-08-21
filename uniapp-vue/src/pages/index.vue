<template>
    <view class="content">
        <view class="header">
            <view class="title">GoEasy Websocket示例</view>
            <view class="description">Uniapp Vue3 Hello world</view>
        </view>
        <view class="send-box">
            <input v-model="message" @confirm="sendMessageByEnter"/>
            <text @click="sendMessage">发送</text>
        </view>
        <view class="message-content">
            <view class="message-text" v-for="(msg, index) in messages" :key="index">{{ msg }}</view>
        </view>
        <view class="version">{{ versionName }}</view>
    </view>
</template>

<script setup>
import {ref, inject} from 'vue'
import {onLoad} from "@dcloudio/uni-app";
import * as config from '../manifest.json';
const versionName = config.versionName;
const goEasy = inject('goEasy');

let message = ref('')
let messages = ref([])

onLoad(() => {
    //连接GoEasy
    connectGoEasy()
    //接收消息
    subscribe()
});

function connectGoEasy () {
    goEasy.connect({
        onSuccess: () => {
            console.log("GoEasy connect successfully.")
            unshiftMessage("连接成功")
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

function sendMessageByEnter(event) {
    message.value = event.detail.value;
    sendMessage();
}

function sendMessage () {
    if (message.value.trim() !== "") {
        let notificationBody = message.value;
        if (message.value.length >= 50) {
          notificationBody = message.value.substring(0, 30) + "...";
        }
        goEasy.pubsub.publish({
            channel: "my_channel",
            message: message.value,
            //只要接收端APP参数以及GoEasy控制台参数正确配置，并且allowNotification为true，就可以接收通知栏提醒
            //若不需要通知栏提醒，可以直接删掉notification
            notification: {
                title: "收到一条新消息",
                body: notificationBody,      // 字段最长50字符
                sound: "message"
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

function formatDate(date) {
  const hours = ("0" + date.getHours()).slice(-2);
  const minutes = ("0" + date.getMinutes()).slice(-2);
  return hours + ":" + minutes;
}

</script>

<style>
uni-page-body {
    height: 100%;;
}
.content {
    padding: 0 40rpx;
    height: 100%;
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.header {
    display: flex;
    flex-direction: column;
    align-items: center;
    color: #D02129;
    margin-top: 100rpx;
}

.header .title {
    color: #D02129;
    font-weight: bold;
    font-size: 52rpx;
    line-height: 66rpx;
}

.header .description {
    color: #D02129;
    font-size: 40rpx;
    line-height: 66rpx;
}

.send-box {
    display: flex;
    flex-direction: row;
    height: 80rpx;
    margin-top: 64rpx;
    margin-bottom: 64rpx;
}

.send-box input {
    flex-grow: 1;
    background: #EFEFEF;
    border: 2rpx solid #C8C7CC;
    border-radius: 12rpx;
    padding: 16rpx;
    font-size: 34rpx;
}

.send-box text {
    color: #D02129;
    margin-left: 18rpx;
    font-size: 34rpx;
    height: 80rpx;
    line-height: 80rpx;
    width: 80rpx;
    text-align: right;
}

.message-content {
    flex: 1;
    margin-bottom: 100rpx;
    overflow-y: auto;
    background: #FFFFFF;
    border: 2rpx solid #DADADA;
    margin-top: 52rpx;
    scrollbar-width: thin;
}

.message-content::-webkit-scrollbar {
   width: 10rpx;
   height: 10rpx;
}
/*滚动条里面小方块*/
.message-content::-webkit-scrollbar-thumb {
   border-radius: 20rpx !important;
   background:#b6b6b6!important;
}

.message-text {
    padding: 8rpx 22rpx;
    font-size: 34rpx;
}

.version {
    text-align: center;
    line-height: 60rpx;
    font-size: 36rpx;
    color: #FFFFFF;
    user-select: text;
}
</style>
