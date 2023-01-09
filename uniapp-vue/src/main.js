import Vue from 'vue'
import App from './App'
import GoEasy from './lib/goeasy-2.5.11.min.js';

const goEasy = GoEasy.getInstance({
  host:"hangzhou.goeasy.io",//应用所在的区域地址: 【hangzhou.goeasy.io |singapore.goeasy.io】
  appkey:"BC-xxxx",// common key
  // true表示支持通知栏提醒，false则表示不需要通知栏提醒
  allowNotification:true, //仅有效于app，小程序和H5将会被自动忽略
  modules: ['pubsub'],
});

Vue.prototype.goEasy = goEasy;


/****
 * 点击APP通知栏消息触发，请将APP安装在手机上体验
 * 可根据消息数据，执行不同的业逻辑，比如跳转到不同的页面，或显示不同的内容
 */
goEasy.onClickNotification((notificaionMessage) => {
  console.log("User clicked the notification:", notificaionMessage);
});



goEasy.connect({
  onSuccess: function(){
    console.log("GoEasy connect successfully.")
  },
  onFailed: function(error){
    console.log("Failed to connect GoEasy, code:"+error.code+ ",error:"+error.content);
    uni.showModal({
      title: error.code.toString(),
      content: error.content,
      showCancel: false,
      duration: 6000
    })
  },
  onProgress: function(attempts){
    console.log("GoEasy is connecting", attempts);
  }
});


Vue.config.productionTip = false
App.mpType = 'app'
const app = new Vue({
  ...App
})
app.$mount()
