<template>
  <view class="content">
    <view class="header">
      <view class="title">GoEasy示例 - UniCloud</view>
      <view class="description">Hello world</view>
    </view>
    <view class="send-box">
      <input v-model="message"/>

      <view class="send-btn">
        <button @click="clientSend">客户端发送</button>
        <button @click="uniCloudSend">服务端(UniCloud)发送</button>
      </view>

    </view>


    <view class="message-content">
      <view class="message-text" v-for="(msg, index) in messages" :key="index">{{ msg }}</view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      message: "", //发送的消息内容
      messages: [] //接收到的消息列表
    }
  },
  onLoad() {
    //与GoEasy建立websocket连接
    this.connectGoEasy();

    //订阅GoEasy websocket消息
    this.subscribe();
  },
  methods: {
    connectGoEasy() {
      this.goEasy.connect({
        onSuccess: () => {
          console.log("GoEasy connect successfully.")
          this.unshiftMessage("连接成功")
        },
        onFailed: (error) => {
          console.log("Failed to connect GoEasy, code:" + error.code + ",error:" + error.content);
          uni.showModal({
            title: error.code.toString(),
            content: error.content,
            showCancel: false,
            duration: 6000
          })
        },
        onProgress: (attempts) => {
          console.log("GoEasy is connecting", attempts);
        }
      });
    },
    subscribe() {
      this.goEasy.pubsub.subscribe({
        channel: "channel_hello",
        onMessage: (message) => {
          this.unshiftMessage(message.content)
        },
        onSuccess: () => {
          this.unshiftMessage("订阅成功")
        },
        onFailed: (error) => {
          this.unshiftMessage("订阅失败，错误编码：" + error.code + " 错误信息：" + error.content);
        }
      });
    },
    //客户端发送
    clientSend() {
      if (this.message.trim() !== "") {
        let notificationBody = this.message;
        if (this.message.length >= 50) {
          notificationBody = this.message.substring(0, 30) + "...";
        }

        this.goEasy.pubsub.publish({
          channel: "channel_hello",
          message: 'client: ' + this.message,
          //只要接收端APP参数以及GoEasy控制台参数正确配置，并且allowNotification为true，就可以接收通知栏提醒
          //若不需要通知栏提醒，可以直接删掉notification
          notification: {
            title: "收到一条新消息",
            body: notificationBody // 字段最长50字符
          },
          onSuccess: () => {
            this.message = ''; //清空发送消息内容
          },
          onFailed: (error) => {
            this.unshiftMessage("消息发送失败，错误编码：" + error.code + " 错误信息：" + error.content);
          }
        });

      }
    },


    //服务端UniCloud发送
    uniCloudSend() {
      if (this.message.trim() !== "") {
        let self = this;
        uniCloud.callFunction({
          name: "goeasy-websocket-publish",
          data: {
            channel: "channel_hello",
            content: this.message
          },
          success(data) {
            if (data.result.status === 200) {
              self.message = "";
            } else {
              self.unshiftMessage("uniCloud发送失败，code：" + data.result.data.code + " error：" + data.result.data.content);
            }
          },
          fail(e) {
            console.log("call unicloud fail:", e)
          }
        });
      }
    },


    //展示消息
    unshiftMessage(content) {
      var formattedTime = this.formatDate(new Date(), "hh:mm");
      var message = formattedTime + " " + content;
      this.messages.unshift(message);
    },
    formatDate(date) {
      const hours = ("0" + date.getHours()).slice(-2);
      const minutes = ("0" + date.getMinutes()).slice(-2);
      return hours + ":" + minutes;
    }
  }
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
  flex-direction: column;
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

.send-box button {
  color: #D02129;
  margin-top: 9px;
  font-size: 15px;
  height: 40px;
  line-height: 40px;
}

.send-btn {
  display: flex;
  justify-content: space-between;

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
