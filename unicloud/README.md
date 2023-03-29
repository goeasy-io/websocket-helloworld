# UniCloud-GoEasy Websocket Hello world


## 体验说明

### 前置条件
* 注册了GoEasy账号，并且已经创建了GoEasy应用
* 已经掌握uniCloud云函数的基本使用

### 运行步骤

#### 1. 创建uniCloud云开发环境
* 将helloworld/unicloud目录导入HbuilderX
* 在unicloud目录点击右键，选择创建uniCloud云开发环境，创建后关联您的云空间

#### 2. 替换appkey
* 打开`main.js`文件， 将appkey替换为您的GoEasy应用的common key
* 打开`uniCloud/cloudfunctions/goeasy-websocket-publish/index.js`，将appkey替换为您的GoEasy应用的common key

#### 3. 将云函数上传到您的云空间，连接云端函数或运行本地云函数
* 在`uniCloud/cloudfunctions/goeasy-websocket-publish`目录上单击右键，选择上传部署

#### 4. 将应用运行到浏览器，即可体验客户单与客户端之间的websocket通讯，也可以体验服务端UniCloud给客户端发送websocket消息





