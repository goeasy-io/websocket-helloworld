//
//  helloworldApp.swift
//  helloworld
//
//  Created by xiao on 2023/7/13.
//

import SwiftUI
import GoEasySDK

@main
struct helloworldApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {

   func application(
           _ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        GoEasy.initSDK(
            host: GoEasyConfig.host,
            appkey: GoEasyConfig.appkey,
            notification: true)
        // 监听通知点击事件
        GoEasy.notification.onClick { data in
            // UI 操作与页面跳转必须在主线程进行
            DispatchQueue.main.async {
                // 在这里编写页面跳转逻辑
                print("点击通知 data: \(data)")
            }
        }

     return true
   }

    // APNs 设备令牌回传 GoEasy 服务器
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs 注册成功: \(deviceToken)")
        GoEasy.notification.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 注册失败: \(error)")
    }
}
