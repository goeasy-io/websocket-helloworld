import {createApp} from 'vue'
import GoEasy from 'goeasy'

const goEasy = GoEasy.getInstance({
  host: 'hangzhou.goeasy.io',	//应用所在的区域地址: 【hangzhou.goeasy.io |singapore.goeasy.io】
  appkey: 'BC-xxxx',	// common key,
  modules: ['pubsub'],
});

const App = createApp();

App.provide('goEasy', goEasy);

export default App
