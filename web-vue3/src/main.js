import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import GoEasy from 'goeasy'

const goEasy = GoEasy.getInstance({
    host: 'hangzhou.goeasy.io', //应用所在的区域地址: 【hangzhou.goeasy.io |singapore.goeasy.io】
    appkey: 'BC-xxxx', // common key,
    modules: ['pubsub'],
});


const app = createApp(App)
app.provide('goEasy', goEasy);

app.use(router).mount('#app')
