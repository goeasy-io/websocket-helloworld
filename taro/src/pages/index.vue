<template>
  <view class="content">
    <view class="header">
      <view class="title">GoEasy Websocket示例</view>
      <view class="description">Taro Vue3 Hello world</view>
    </view>
    <view class="send-box">
      <input class="send-input" v-model="content" />
      <view class="send-button" @tap="sendMessage">发送</view>
    </view>
    <view class="message-content">
      <view class="message-text" v-for="(message, index) in messages" :key="index">{{ message }}</view>
    </view>
  </view>
</template>

<script setup>
import {ref, inject} from 'vue';
import {useLoad} from '@tarojs/taro'
const goEasy = inject('goEasy');

let messages = ref([]);
let content = ref('');

useLoad(() => {
  //连接GoEasy
  connectGoEasy()
  //接收消息
  subscribe()
})

function connectGoEasy() {
  goEasy.connect({
    onProgress: function (attempts) {
      console.log("GoEasy is connecting", attempts);
      unshiftMessage("连接成功")
    },
    onSuccess: function () {
      console.log("GoEasy connect successfully.")
    },
    onFailed: function (error) {
      unshiftMessage("Failed to connect GoEasy, code:" + error.code + ",error:" + error.content);
    }
  });
}

function subscribe() {
  goEasy.pubsub.subscribe({
    channel: "my_channel",
    onMessage: function (message) {
      unshiftMessage(message.content);
    },
    onSuccess: function () {
      unshiftMessage('订阅成功.');
    },
    onFailed: function (error) {
      unshiftMessage("订阅失败，错误编码：" + error.code + " 错误信息：" + error.content);
    }
  });
}

function sendMessage() {//发送消息
  if (content.value.trim() !== '') {
    //发送消息
    goEasy.pubsub.publish({
      channel: "my_channel",
      message: content.value,
      onSuccess: function () {
        content.value = "";
        console.log("send message success");
      },
      onFailed: function (error) {
        unshiftMessage("消息发送失败，错误编码：" + error.code + " 错误信息：" + error.content);
      }
    });
  }
}

function unshiftMessage(content) {
  let formattedTime = formatDate(new Date(), "hh:mm");
  let message = formattedTime + " " + content;
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
        format = format.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    }
  return format;
}
</script>

<style>
.taro_page {
  width: 100%;
  height: 100%;
}
.content {
  padding: 40px 40px 0 40px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.header {
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #D02129;
  margin-top: 100px;
}

.header .title {
  color: #D02129;
  font-weight: bold;
  font-size: 52px;
  line-height: 66px;
}

.header .description {
  color: #D02129;
  font-size: 40px;
  line-height: 66px;
}

.send-box {
  display: flex;
  flex-direction: row;
  height: 80px;
  margin-top: 64px;
  margin-bottom: 64px;
}

.send-box .send-input {
  flex-grow: 1;
  background: #EFEFEF;
  border: 2px solid #C8C7CC;
  border-radius: 12px;
  padding: 16px;
  font-size: 28px;
}

.send-box .send-button {
  color: #D02129;
  margin-left: 18px;
  font-size: 30px;
  height: 80px;
  line-height: 80px;
  width: 80px;
  text-align: right;
}

.message-content {
  height: 750px;
  overflow-y: auto;
  background: #FFFFFF;
  border: 2px solid #DADADA;
  margin-top: 52px;
  scrollbar-width: thin;
}

.message-content::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}
/*滚动条里面小方块*/
.message-content::-webkit-scrollbar-thumb {
  border-radius: 20px !important;
  background:#b6b6b6!important;
}

.message-text {
  padding: 8px 22px;
  font-size: 30px;
}
</style>
