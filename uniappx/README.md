# uniappx - GoEasy Websocket HelloWorld（uni-app x / UTS）

本示例演示在 **uni-app x（UTS）** 中接入 GoEasy PubSub，实现：

- 连接 GoEasy、订阅频道、接收消息
- 发布消息（可选：携带通知栏推送参数）
- 历史消息查询、取消订阅、断开连接

## 项目结构

```text
uniappx/
  App.uvue                         应用生命周期
  main.uts                          应用入口：初始化 GoEasy 实例（appkey/host/模块）
  manifest.json                     应用基础配置（appid/version/发行配置等）
  pages.json                        页面路由配置
  pages/
    index/
      index.uvue                    页面：连接/订阅/发送/历史/断开等示例逻辑
  nativeResources/
    android/
      manifestPlaceholders.json     Android 厂商通道/FCM 等占位配置（通知推送相关）
      res/raw/
        message.mp3                 Android 通知声音资源（sound: "message"）
        ring.mp3
    ios/
      Resources/
        message.caf                 iOS 通知声音资源（sound: "message"）
        ring.caf
  harmony-configs/                  HarmonyOS 工程/签名相关配置（打包用）
  uni_modules/
    goeasy-websocket/               GoEasy uni-app x 插件（UTS）
```


## 运行前准备（必做）

1. **准备 GoEasy 账号与应用**
   - 在 GoEasy 控制台创建应用，获取 `appkey`
2. **配置 GoEasy AppKey**
   - 修改 `main.uts` 中：
     - `appkey: '你的appkey'`
     - `host: 'hangzhou.goeasy.io'`（按你的区域选择）


## 各平台运行步骤

使用 **HBuilderX（支持 uni-app x）** 打开 `uniappx/` 目录运行。

### Web（H5）

- HBuilderX 打开 `uniappx/`
- 运行到浏览器（H5）

### App-Android（仅真机）

- HBuilderX 打开 `uniappx/`
- 制作自定义基座
- 运行到 Android 设备

### App-iOS（仅真机）

- HBuilderX 打开 `uniappx/`
- 制作自定义基座
- 运行到 iOS 真机


### HarmonyOS

- HBuilderX 打开 `uniappx/`
- `harmony-configs/build-profile.json5`文件中配置鸿蒙证书参数
- 运行鸿蒙



## 通知 栏推送打包与配置说明

### 1) 自定义铃声：
#### 将铃声资源放到下面目录

- Android：`nativeResources/android/res/raw/`
- iOS：`nativeResources/ios/Resources/`

#### 在发布消息时使用：

- `notification.sound: "message"` 对应 `message.mp3` / `message.caf`

### 2) Android 厂商通道 / FCM 配置（可选）
#### 将厂商参数填写到`nativeResources/android/manifestPlaceholders.json`文件中

```text
{
    "HUAWEI_APPID": "107680123",                                  // 替换为您的华为APP ID(ClientID)
    "HONOR_APPID": "900742123",                                   // 替换为您的荣耀APP ID
    "VIVO_APPID": "105625123",                                    // 替换为您的VIVO AppID
    "VIVO_APPKEY": "1c53bedb63e2130e9e10807e04edf123",            // 替换为您的VIVO AppKey
    "XIAOMI_APPID": "2882303761520221123",                        // 替换为您的小米AppID
    "XIAOMI_APPKEY": "52420221123",                               // 替换为您的小米AppKey
    "MEIZU_APPID": "151123",                                      // 替换为您的魅族App ID
    "MEIZU_APPKEY": "cc0c00d453b0456ba3fc4b5137e5e123",           // 替换为您的魅族App Key
    "OPPO_APPID": "30962123",                                     // 替换为您的OPPO appid
    "OPPO_APPKEY": "49ff52d6b0684041a1594f40c5461123",            // 替换为您的OPPO appkey
    "OPPO_APPSECRET": "f479bce1767a4a5d935ee78438881123",         // 替换为您的OPPO appsecret
    "FCM_PROJECT_ID": "goeasy-123",                               // 替换为您的FCM Project ID
    "FCM_APPID": "1:691004149542:android:c156fd63cffbfd2f363123", // 替换为您的FCM App ID
    "FCM_CURRENT_KEY": "AIzaSyCc704udx8m27uXlFXXhvfWnewfffu0123"  // 替换为您的FCM current_key
}
```


### 3) HarmonyOS 打包签名配置（可选）

- 目录：`harmony-configs/`
- 文件：
  - `harmony-configs/build-profile.json5`：签名配置与构建产物配置
  - `harmony-configs/entry/src/main/module.json5`：模块信息、权限、metadata（填写 `client_id`）


```json5
"metadata": [
  {
	"name": "client_id",
	"value": "6917575502611302123" // "替换为您的鸿蒙 appId/clientId"
  }
],
```

