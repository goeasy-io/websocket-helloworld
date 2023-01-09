import { createApp } from 'vue'
import App from './App.vue'
import GoEasy from 'goeasy'

const goEasy = GoEasy.getInstance({
    host: 'hangzhou.goeasy.io', //应用所在的区域地址: [hangzhou.goeasy.io, 新加坡暂不支持IM，敬请期待]
    appkey: 'BC-xxxx', // common key,
    modules: ['pubsub'],
});


const app = createApp(App)
app.provide('GoEasy', GoEasy);
app.provide('goEasy', goEasy);

app.mount('#app')