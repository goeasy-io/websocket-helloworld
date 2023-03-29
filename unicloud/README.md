# UniCloud-GoEasy Websocket Hello world


## 体验说明




### 模式一 简单模式

#### 前置条件
* 注册了GoEasy账号，并且已经创建了GoEasy应用
* 已经掌握uniCloud云函数的基本使用

#### 1. 替换客户端appkey, 体验客户端消息发送和接收
打开`mani.js`文件， 将appkey替换为您的GoEasy应用的common key

#### 2. 替换uniCloud云函数里的appkey
* 找到文件`uniCloud-aliyun/cloudfunctions/goeasy-websocket-message/index.js`，将appkey替换为您的GoEasy应用的common key
* 将云函数关联到您的任意云空间

#### 3. 将应用运行到浏览器，即可体验客户单与客户端之间的websocket通讯，也可以体验服务端UniCloud给客户端发送websocket消息




****
   分割线  
****



### 模式二 更安全模式（强制验证授权）


#### 前置条件
* 注册了GoEasy账号，并且已经创建了GoEasy付费应用（至少需要购买了9.9的套餐）
* 已经掌握uniCloud云函数的基本使用

#### 更换应用启动页
打开`main.js`文件，将启动页从`pages/index/index`切换为`pages/index/index-accesstoken`

#### 1. 替换客户端appkey, 体验客户端消息发送和接收
打开`mani.js`文件， 将appkey替换为您的GoEasy应用的common key

#### 2. 设置发送云函数里的appkey
找到文件`uniCloud-aliyun/cloudfunctions/goeasy-websocket-message/index.js`
* 将appkey替换为您的GoEasy应用的common key
* 将云函数关联到您的任意云空间


#### 3. 替换生成AccessToken的Secret Key
找到文件`uniCloud-aliyun/cloudfunctions/goeasy-generate-accesstoken/index.js`
* 将secretKey替换为您的GoEasy应用的Secret Key

#### 4. 将应用运行到浏览器，即可体验客户单与客户端之间的websocket通讯，也可以提到到服务单UniCloud给客户端发送websocket消息



#### 5.关于客户端安全与访问控制的文档 
https://goeasy.io/cn/docs/goeasy-2.x/common/security/authorization/





