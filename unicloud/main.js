import Vue from 'vue'
import App from './App'


import GoEasy from '@/uni_modules/goeasy-js/js_sdk/goeasy-2.6.4.esm.min.js'

const goEasy = GoEasy.getInstance({
	host:"hangzhou.goeasy.io",//应用所在的区域地址: 【hangzhou.goeasy.io |singapore.goeasy.io】
	appkey:"BC-xxx",// common key
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


Vue.config.productionTip = false

App.mpType = 'app'

const app = new Vue({
    ...App
})
app.$mount()
