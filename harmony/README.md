# GoEasy HarmonyOS HelloWorld（鸿蒙示例）

本目录为 GoEasy Websocket（PubSub）在 HarmonyOS的最简 Demo。

## 运行前准备

- 安装并配置 **DevEco Studio**（含对应 HarmonyOS SDK）
- 准备一台设备或模拟器（Phone）

## 1. 修改 AppKey（必做）

在 `entry` 模块中修改 AppKey：

- 文件：`harmony/entry/src/main/ets/entryability/EntryAbility.ets`
- 位置：`GoEasy.init({ appkey: "BC-xxx" })`
- 将 `"BC-xxx"` 替换为你在 GoEasy 控制台创建应用后获取的 AppKey

## 2. 本地依赖说明（已内置）

本 Demo 使用本地 `.har` 方式引入 SDK：

- SDK 包：`harmony/entry/libs/goeasy.har`
- 依赖声明：`harmony/entry/oh-package.json5`

```json
{
  "dependencies": {
    "goeasy": "file:libs/goeasy.har"
  }
}
```

## 3. 安装依赖

在 DevEco Studio 中打开 `harmony/` 工程后，执行一次依赖同步/安装（任意一种方式即可）：

- 使用 IDE 的 **Sync/Install** 功能（推荐）
- 或在项目根目录执行 `ohpm install`（如果你的环境已安装并配置 ohpm）

## 4. 编译运行

在 DevEco Studio 中：

- 选择 `entry` 模块
- 选择设备/模拟器
- 点击 **Run** 运行

## 5. 验证效果

启动后进入主页面（`pages/Index`）：

- 自动连接 GoEasy
- 自动订阅频道：`my_channel`
- 输入内容点击“发送”会向 `my_channel` 发布消息，并在消息列表里看到收发记录


## 6. 通知栏推送功能配置

- `entry/build-profile.json5`：签名配置与构建产物配置
- `entry/src/main/module.json5`：模块信息、权限、metadata（填写 `client_id`）



## 常见问题

- 如果连接失败：请确认 AppKey 正确、设备网络正常，且已声明网络权限（本工程 `entry/src/main/module.json5` 已包含 `ohos.permission.INTERNET`）。

