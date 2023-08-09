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
node版本要求14及以上
```
npm install
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
        'channel':'my_channel',
        'content':'Hello, GoEasy!'
    }"
    
````

##### 温馨提示

如果demo与您本地的环境版本不一致，重新安装依赖比较繁琐，或运行失败，您可以尝试以下方法解决：

1.创建一个新的ReactNative新项目
````shell
npx react-native init AwesomeProject --version x.xx.x
````

2.运行AwesomeProject项目，确保该项目能运行成功

3.将page目录、App.js、index.js拷贝替换到您项目中

5.安装GoEasy所需依赖
````shell
npm install goeasy @react-native-async-storage/async-storage
````

6.再次运行项目
