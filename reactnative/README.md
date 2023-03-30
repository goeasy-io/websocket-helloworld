## GoEasy Websocket RectNative HelloWorld示例运行步骤

### 免费获取appkey
1. 访问[GoEasy官网](https://www.goeasy.io)进行注册
2. 登陆后，创建一个应用
3. 进入应用详情，即可看到自己的appkey

### 替换appkey
打开index.js，找到初始化GoEasy的地方，将appkey替换成您应用的common key

### 运行步骤

将目录切换到helloworld/reactnative/

##### 搭建开发环境

根据你所使用的操作系统、针对的目标平台不同，具体步骤有所不同。参考ReactNative官网[搭建开发环境](https://reactnative.cn/docs/environment-setup)，demo运行依赖版本参考`.node-version`及`.ruby-version`文件。


##### 安装依赖
```
npm ci
```

##### 运行服务

参考ReactNative官网[在设备上运行](https://reactnative.cn/docs/running-on-device)


### 体验服务端发送
可以用Postman或curl发送消息到GoEasy，体验服务端发送消息到客户端。

````shell
curl -X POST https://rest-hz.goeasy.io/v2/pubsub/publish \
-H "Content-Type: application/json" \
-d "{
        'appkey':'您的appkey',
        'channel':'test_channel',
        'content':'Hello, GoEasy!'
    }"
    
````
