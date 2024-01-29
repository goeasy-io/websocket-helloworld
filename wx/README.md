
## GoEasy Websocket微信小程序HelloWorld示例运行步骤

### 免费获取appkey
1. 访问[GoEasy官网](https://www.goeasy.io)进行注册
2. 登陆后，创建一个应用
3. 进入应用详情，即可看到自己的appkey

### 替换appkey
打开app.js，找到初始化GoEasy的地方，将appkey替换成您应用的common key


### 小程序注意事项
需要登录微信公众平台->微信小程序开发设置->服务器域名, 添加以下所有5个socket合法域名：  
wss://1hangzhou.goeasy.io  
wss://2hangzhou.goeasy.io  
wss://3hangzhou.goeasy.io  
wss://4hangzhou.goeasy.io  
wss://5hangzhou.goeasy.io

### 体验
建议可以同时在小程序开发工具和手机上同时运行，体验多个客户端之间互动。

### 体验服务端发送
可以用Postman或curl发送消息到GoEasy，体验服务端发送消息到客户端。

````shell
curl -X POST https://rest-hz.goeasy.io/v2/pubsub/publish \
-H "Content-Type: application/json" \
-d "{
        'appkey':'您的appkey',
        'channel':'my_channel',
        'content':'Hello, GoEasy!'
    }"
    
````
