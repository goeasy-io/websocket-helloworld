## GoEasy Websocket iOS HelloWorld示例运行步骤

### 免费获取appkey
1. 访问[GoEasy官网](https://www.goeasy.io)进行注册
2. 登陆后，创建一个应用
3. 进入应用详情，即可看到自己的appkey

### 替换appkey
打开GoEasyConfig.swift，将appkey替换成您应用的common key

### 运行步骤

将目录切换到helloworld/iOS/

##### 安装依赖

```
pod install
```

##### 运行服务

Xcode打开helloworld/iOS/helloworld.xcworkspace，运行即可


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
