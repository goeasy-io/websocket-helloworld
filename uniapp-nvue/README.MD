## GoEasy Websocket Uniapp helloWorld示例(NVUE)运行步骤


### 免费获取appkey
1. 访问[GoEasy官网](https://www.goeasy.io)进行注册
2. 登陆后，创建一个应用
3. 进入应用详情，即可看到自己的appkey

### 替换appkey
打开main.js，找到初始化GoEasy的地方，将appkey替换成您应用的common key  

### 体验
建议可以同时在多个手机运行，体验多个客户端之间互动。

### 体验通知栏提醒
* 将Uniapp应用运行到手机上
* 检查手机"系统设置"的通知推送里，确保该app的状态为“允许”
* 将Uniapp应用运行到浏览器里，发送一条消息
    * 若手机APP在前台运行，APP内收到消息
    * 若手机APP在后台运行，手机收到通知栏提醒

### 接入厂商通道
如果希望APP进程被杀掉后，仍然可以收到通知栏提醒，必须要接入厂商通道，详情请参阅[GoEasy接入厂商通道教程](https://docs.goeasy.io/2.x/common/notification/manufacturer_integration)。



