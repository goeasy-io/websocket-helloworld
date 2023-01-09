## 支持App,NVUE,VUE,H5,微信小程序和厂商通道

### 替换您的appkey
打开app.vue，找到初始化GoEasy的地方，将appkey替换成您自己的appkey。  

### 小程序注意事项
如果开发微信小程序，需要登录到微信官方后台，将wx-hangzhou.goeasy.io加入到socket合法域名列表

### 还没有appkey？  
1. 请先去[GoEasy官网](https://www.goeasy.io)进行注册
2. 创建一个应用
3. 在应用详情页面即可查看到appkey

### 体验
建议可以同时在浏览器和手机同时运行，体验多个客户端之间互动。

### 体验通知栏提醒
* 将Uniapp应用运行到手机上
* 检查手机"系统设置"的通知推送里，确保该app的状态为“允许”
* 将Uniapp应用运行到浏览器里，发送一条消息
    * 若手机APP在前台运行，APP内收到消息
    * 若手机APP在后台运行，手机收到通知栏提醒

### 接入厂商通道
如果希望APP进程被杀掉后，仍然可以收到通知栏提醒，必须要接入厂商通道，详情请参阅[GoEasy接入厂商通道教程](https://www.goeasy.io/cn/doc/notification/manufacturer_integration.html)。

