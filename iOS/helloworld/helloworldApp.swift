//
//  helloworldApp.swift
//  helloworld
//
//  Created by xiao on 2023/7/13.
//

import SwiftUI
import UIKit
import GoEasySwift

@main
struct helloworldApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GNotification.setup()
        GNotification.setNotificationClickCallback(self.onNotificationClicked)

        return true
    }
    
    func application(_ application: UIApplication,
                         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        GNotification.registerPush(deviceToken)
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }

    func onNotificationClicked(_ ext: [String: Any]) {
        print("Notification clicked with ext: \(ext)")
        
    }

}

