import App from './App'

import {GoEasyUts as GoEasy} from '@/uni_modules/goeasy-websocket'

GoEasy.getInstance({
  host:"hangzhou.goeasy.io",
  appkey:'BC-xxx',
  modules: ["pubsub"],
  allowNotification: true
})

uni.$GoEasy = GoEasy

// #ifdef VUE3
import { createSSRApp } from 'vue'
export function createApp() {
  const app = createSSRApp(App)
  return {
    app
  }
}
// #endif