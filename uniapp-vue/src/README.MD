## GoEasy Websocket Uniapp helloWorld示例(Vue3)运行步骤

本示例，可以编译为H5、ios app和android ios和微信小程序，以及其他各种小程序

### 免费获取appkey
1. 访问[GoEasy官网](https://www.goeasy.io)进行注册
2. 登陆后，创建一个应用
3. 进入应用详情，即可看到自己的appkey

### 替换appkey
打开main.js，找到初始化GoEasy的地方，将appkey替换成您应用的common key


### 小程序注意事项
如果编译为微信小程序，需要登录到微信官方后台，将wx-hangzhou.goeasy.io加入到socket合法域名列表

### 体验
建议可以同时运行到多个终端（比如h5或app），体验多个客户端之间互动。

### 体验服务端发送
可以用Postman或curl发送消息到GoEasy，体验服务端发送消息到客户端。

````shell
curl -X POST https://rest-hz.goeasy.io/v2/pubsub/publish \
-H "Content-Type: application/json" \
-d "{
        'appkey':'您的appkey',
        'channel':'test_channel',
        'content':'Hello, GoEasy!',
        'notification':{    //可选，通知栏提醒
            'title':'title',
            'body':'body'
        }
    }"
    
````

### 体验通知栏提醒
* 将Uniapp应用运行到手机上
* 检查手机"系统设置"的通知推送里，确保该app的状态为“允许”
* 将Uniapp应用运行到浏览器里，发送一条消息
    * 若手机APP在前台运行，APP内收到消息
    * 若手机APP在后台运行，手机收到通知栏提醒

### 接入厂商通道
如果希望APP进程被杀掉后，仍然可以收到通知栏提醒，必须要接入厂商通道，详情请参阅[GoEasy接入厂商通道教程](https://docs.goeasy.io/2.x/common/notification/manufacturer_integration)。



