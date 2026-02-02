import Foundation
import GoEasySwift
import UIKit
import UserNotifications

/// GoEasy Swift 桥接层
/// 用于处理 UTS 无法直接调用的 Swift 命名参数方法
/// UTS 原生混编中，Swift 文件会被自动编译，UTS 可以直接调用，无需 @objc
public class GoEasyBridge {

    public static func initGoEasy(_ host: String, _ appkey: String, _ modules: [String], _ allowNotification: Bool?) {
        let options = GoEasySwift.V2Api.Common.InitOptions(
            host: host,
            appkey: appkey,
            modules: modules,
            allowNotification: allowNotification ?? false
        )
        GoEasy.initGoEasy(options: options)
    }

    public static func connect(
        _ id: String?,
        _ data: [String: String]?,
        _ otp: String?,
        _ onSuccess: @escaping ((Any) -> Void),
        _ onFailed: @escaping (([String: Any]) -> Void),
        _ onProgress: @escaping ((Int32) -> Void)
    ) {
        let options = GoEasySwift.V2Api.Common.ConnectOptions(
            id: id,
            data: data,
            otp: otp,
            onSuccess: {
                DispatchQueue.main.async {
                    onSuccess(0)
                }
            },
            onFailed: { result in
                let resultDict: [String: Any] = [
                    "code": result.code,
                    "data": result.data
                ]
                DispatchQueue.main.async {
                    onFailed(resultDict)
                }
            },
            onProgress: { attempts in
                DispatchQueue.main.async {
                    onProgress(Int32(attempts))
                }
            }
        )
        GoEasy.connect(options: options)
    }
    

    public static func disconnect(
        _ onSuccess: @escaping ((Any) -> Void),
        _ onFailed: @escaping (([String: Any]) -> Void)
    ) {
        let options = GoEasySwift.V2Api.Common.DisConnectOptions(
            onSuccess: {
                DispatchQueue.main.async {
                    onSuccess(0)
                }
            },
            onFailed: { result in
                let resultDict: [String: Any] = [
                    "code": result.code,
                    "data": result.data
                ]
                DispatchQueue.main.async {
                    onFailed(resultDict)
                }
            }
        )
        GoEasy.disconnect(options: options)
    }

}

// /// GPubSub 桥接层
public class GPubSubBridge {

    public static func publish(
        _ channel: String,
        _ message: String,
        _ qos: Int32?,
        _ notification: [String: Any]?,
        _ onSuccess: @escaping ((Any) -> Void),
        _ onFailed: @escaping (([String: Any]) -> Void)
    ) {
        var notificationOptions: GoEasySwift.V2Api.Common.NotificationOptions? = nil
        if let n = notification {
            var vendorOptions: GoEasySwift.V2Api.Common.VendorOptions? = nil
            if let v = n["vendorOptions"] as? [String: Any] {
                var huawei: GoEasySwift.V2Api.Common.HuaweiOptions? = nil
                if let h = v["huawei"] as? [String: Any] {
                    huawei = GoEasySwift.V2Api.Common.HuaweiOptions(category: h["category"] as? String ?? "")
                }
                var xiaomi: GoEasySwift.V2Api.Common.XiaomiOptions? = nil
                if let x = v["xiaomi"] as? [String: Any] {
                    let channelId: GoEasySwift.V2Api.Common.ChannelId
                    if let s = x["channel_id"] as? String {
                        channelId = .stringValue(s)
                    } else if let i = x["channel_id"] as? Int {
                        channelId = .intValue(i)
                    } else {
                        channelId = .stringValue("")
                    }
                    xiaomi = GoEasySwift.V2Api.Common.XiaomiOptions(channel_id: channelId)
                }
                var oppo: GoEasySwift.V2Api.Common.OppoOptions? = nil
                if let o = v["oppo"] as? [String: Any] {
                    oppo = GoEasySwift.V2Api.Common.OppoOptions(channel_id: o["channel_id"] as? String ?? "")
                }
                var vivo: GoEasySwift.V2Api.Common.VivoOptions? = nil
                if let vi = v["vivo"] as? [String: Any] {
                    vivo = GoEasySwift.V2Api.Common.VivoOptions(
                        classification: vi["classification"] as? Int,
                        category: vi["category"] as? String
                    )
                }
                var harmony: GoEasySwift.V2Api.Common.HarmonyOptions? = nil
                if let har = v["harmony"] as? [String: Any] {
                    harmony = GoEasySwift.V2Api.Common.HarmonyOptions(category: har["category"] as? String ?? "")
                }
                vendorOptions = GoEasySwift.V2Api.Common.VendorOptions(
                    huawei: huawei,
                    xiaomi: xiaomi,
                    oppo: oppo,
                    vivo: vivo,
                    harmony: harmony
                )
            }

            notificationOptions = GoEasySwift.V2Api.Common.NotificationOptions(
                title: n["title"] as? String ?? "",
                body: n["body"] as? String ?? "",
                sound: n["sound"] as? String,
                badge: n["badge"] as? String,
                vendorOptions: vendorOptions
            )
        }

        let options = GoEasySwift.V2Api.Pubsub.PublishOptions(
            channel: channel,
            message: message,
            notification: notificationOptions,
            qos: qos,
            onSuccess: {
                DispatchQueue.main.async {
                    onSuccess(0)
                }
            },
            onFailed: { result in
                let resultDict: [String: Any] = [
                    "code": result.code,
                    "data": result.data
                ]
                DispatchQueue.main.async {
                    onFailed(resultDict)
                }
            }
        )

        GoEasy.pubsub.publish(options: options)
    }


    public static func subscribe(
        _ channel: String,
        _ onMessage: @escaping (([String: Any]) -> Void),
        _ onSuccess: @escaping ((Any) -> Void),
        _ onFailed: @escaping (([String: Any]) -> Void)
    ) {
        let options = GoEasySwift.V2Api.Pubsub.SubscribeOptions(
            channel: channel,
            onSuccess: {
                DispatchQueue.main.async {
                    onSuccess(0)
                }
            },
            onFailed: { result in
                let resultDict: [String: Any] = [
                    "code": result.code,
                    "data": result.data
                ]
                DispatchQueue.main.async {
                    onFailed(resultDict)
                }
            },
            onMessage: { message in
                var messageDict: [String: Any] = [
                    "channel": message.channel,
                    "content": message.content
                ]
                if let time = message.time {
                    messageDict["time"] = time
                }
                DispatchQueue.main.async {
                    onMessage(messageDict)
                }
            }
        )

        GoEasy.pubsub.subscribe(options: options)
    }

    public static func unsubscribe(
        _ channel: String,
        _ onSuccess: @escaping ((Any) -> Void),
        _ onFailed: @escaping (([String: Any]) -> Void)
    ) {
        let options = GoEasySwift.V2Api.Pubsub.UnSubscribeOptions(
            channel: channel,
            onSuccess: {
                DispatchQueue.main.async {
                    onSuccess(0)
                }
            },
            onFailed: { result in
                let resultDict: [String: Any] = [
                    "code": result.code,
                    "data": result.data
                ]
                DispatchQueue.main.async {
                    onFailed(resultDict)
                }
            }
        )
        GoEasy.pubsub.unsubscribe(options: options)
    }

    public static func history(
        _ channel: String,
        _ start: Int64?,
        _ end: Int64?,
        _ limit: Int32?,
        _ onSuccess: @escaping (([String: Any]) -> Void),
        _ onFailed: @escaping (([String: Any]) -> Void)
    ) {
        var limitInt: Int? = nil
        if let l = limit {
            limitInt = Int(l)
        }
        let options = GoEasySwift.V2Api.Pubsub.HistoryOptions(
            channel: channel,
            start: start,
            end: end,
            limit: limitInt,
            onSuccess: { response in
                var messagesArray: [[String: Any]] = []
                for msg in response.content.messages {
                    messagesArray.append([
                        "time": msg.time,
                        "content": msg.content
                    ])
                }
                
                let responseDict: [String: Any] = [
                    "code": response.code,
                    "content": [
                        "messages": messagesArray
                    ]
                ]
                
                DispatchQueue.main.async {
                    onSuccess(responseDict)
                }
            },
            onFailed: { result in
                let resultDict: [String: Any] = [
                    "code": result.code,
                    "data": result.data
                ]
                DispatchQueue.main.async {
                    onFailed(resultDict)
                }
            }
        )
        GoEasy.pubsub.history(options: options)
    }

}
