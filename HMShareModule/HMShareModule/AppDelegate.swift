//
//  AppDelegate.swift
//  HMShareModule
//
//  Created by Hehuimin on 2019/8/2.
//  Copyright © 2019 Hehuimin. All rights reserved.
//

import UIKit

// info.plist的URL types中也要设置对应的
private let kWXApiKey: String = "设置APP ID"
private let kQQApiKey: String = "设置APP ID"
private let kWeiboApiKey: String = "设置APP ID"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ShareModule.registerPlatforms { (register) in
            register.setupQQ(appId: kQQApiKey)
            register.setupWechat(appId: kWXApiKey)
            register.setupWeibo(appKey: kWeiboApiKey)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.scheme?.hasPrefix("wx"))! {
            WXApi.handleOpen(url, delegate: self as? WXApiDelegate)
        } else  if (url.scheme?.hasPrefix("wb"))! {
            WeiboSDK.handleOpen(url, delegate: self as? WeiboSDKDelegate)
        } else if (url.scheme?.hasPrefix("tencent"))! {
            TencentOAuth.handleOpen(url)
        }
        return true
    }
}

