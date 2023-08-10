## GoEasy Websocket Taro HelloWorld示例运行步骤

### 免费获取appkey
1. 访问[GoEasy官网](https://www.goeasy.io)进行注册
2. 登陆后，创建一个应用
3. 进入应用详情，即可看到自己的appkey

### 替换appkey
打开app.js，找到初始化GoEasy的地方，将appkey替换成您应用的common key

### 运行步骤

将目录切换到helloworld/taro/

##### 安装依赖
node版本要求12.22以上
```
npm ci
```

##### 运行服务

```
npm run dev:TARO_ENV
```
选择编译平台类型 TARO_ENV : weapp / h5

### 体验
建议可以同时运行在多个浏览器窗口，体验多个客户端之间互动。

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


