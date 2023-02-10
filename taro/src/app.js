import { createApp } from 'vue'
import GoEasy from 'goeasy'

import './app.css'

const goEasy = GoEasy.getInstance({
  host: 'hangzhou.goeasy.io',	//应用所在的区域地址: [hangzhou.goeasy.io, 新加坡暂不支持IM，敬请期待]
  appkey: 'BC-xxxx',	// common key,
  modules: ['pubsub'],
});

const App = createApp();

App.provide('goEasy', goEasy);

export default App
