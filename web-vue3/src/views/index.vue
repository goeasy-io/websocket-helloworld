<template>
  <div class="index">
    <div class="container">
      <div class="header">
        <span class="title">GoEasy示例</span>
        <span class="description">Hello World</span>
      </div>
      <div class="send-box">
        <input v-model="content"/>
        <span @click="sendMessage">发送</span>
      </div>
      <div class="message-container">
        <div class="message-content">
          <div class="message-text" v-for="(message, key) in messages" :key="key">{{ message }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
  import {ref, onBeforeMount, inject} from 'vue';
  const goEasy = inject('goEasy');

  let messages = ref([]);
  let content = ref('');

  onBeforeMount(() => {
    connectGoEasy()
  })

  function connectGoEasy() {
    //连接GoEasy
    goEasy.connect({
      onProgress: function (attempts) {
        console.log("GoEasy is connecting", attempts);
      },
      onSuccess: function () {
        console.log("GoEasy connect successfully.")
        subscribe()
      },
      onFailed: function (error) {
        unshiftMessage("Failed to connect GoEasy, code:" + error.code + ",error:" + error.content);
      }
    });
  }

  function subscribe() {
    //接收消息
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
    if (content.value.trim() != '') {
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
          format = format.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
      }
    return format;
  }
</script>

<style>
  .index {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .container {
    width: 850px;
    height: 650px;
    background: #FFFFFF;
    display: flex;
    flex-direction: column;
  }

  .header {
    margin-top: 70px;
    display: flex;
    flex-direction: column;
    align-items: center;
    color: #D02129;
  }

  .header .title {
    font-size: 24px;
  }

  .header .description {
    margin-top: 10px;
    font-size: 28px;
    line-height: 25px;
    font-weight: bold;
  }

  .send-box {
    height: 40px;
    margin: 32px 0;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .send-box input {
    width: 645px;
    height: 40px;
    background: #EFEFEF;
    border: 1px solid #C8C7CC;
    outline: none;
    border-radius: 6px;
  }

  .send-box span {
    margin-left: 20px;
    color: #D02129;
    text-align: right;
    cursor: pointer;
  }

  .message-container {
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .message-content {
    width: 700px;
    margin-top: 20px;
    background-color: #FFFFFF;
    border: 1px solid #DADADA;
    min-height: 300px;
  }

  .message-text {
    padding: 4px 11px;
  }

</style>
