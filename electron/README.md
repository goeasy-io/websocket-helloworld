## GoEasy Websocket Electron HelloWorld示例运行步骤

### 免费获取appkey
1. 访问[GoEasy官网](https://www.goeasy.io)进行注册
2. 登陆后，创建一个应用
3. 进入应用详情，即可看到自己的appkey

### 替换appkey
打开index.js，找到初始化GoEasy的地方，将appkey替换成您应用的common key

### 运行步骤

将目录切换到helloworld/electron/

##### 安装依赖
```
npm install
```

##### 运行服务

```
npm run start
```

##### 打包构建

```
npm run make
```


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
