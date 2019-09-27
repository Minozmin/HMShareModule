//
//  ShareModule+Base.swift
//  ShareModule
//
//  Created by Hehuimin on 2019/4/10.
//  Copyright © 2019 Hehuimin. All rights reserved.
//

import Foundation

//Weixin
public extension ShareModule {
    //是否安装微信 app
    static func isWXAppInstalled() -> Bool {
        if WXApi.isWXAppInstalled() {
            return true
        }
        return false
    }
    
    //是否可以打开微信
    static func openWXApp() -> Bool {
        if WXApi.openWXApp() {
            return true
        }
        return false
    }

    //处理微信通过URL启动App时传递的数据
    @discardableResult
    static func handleOpenWechat(_ url: URL, delegate: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: delegate as? WXApiDelegate)
    }
}

//QQ
public extension ShareModule {
    //是否安装QQ app
    static func isQQAppInstalled() -> Bool {
        if QQApiInterface.isQQInstalled() {
            return true
        }
        return false
    }
    
    //是否可以打开QQ
    static func openQQApp() -> Bool {
        if QQApiInterface.openQQ() {
            return true
        }
        return false
    }
    
    //处理被其他应用呼起时的逻辑
    @discardableResult
    static func handleOpenQQ(_ url: URL) -> Bool {
        return TencentOAuth.handleOpen(url);
    }
}

//Weibo
public extension ShareModule  {
    //是否安装微博 app
    static func isWeiboAppInstalled() -> Bool {
        if WeiboSDK.isWeiboAppInstalled() {
            return true
        }
        return false
    }
    
    //是否可以打开微信
    static func openWBApp() -> Bool {
        if WeiboSDK.openWeiboApp() {
            return true
        }
        return false
    }
    
    //处理微博客户端程序通过URL启动第三方应用时传递的数据
    @discardableResult
    static func handleOpenWeibo(_ url: URL, delegate: Any) -> Bool {
        return WeiboSDK.handleOpen(url, delegate: delegate as? WeiboSDKDelegate)
    }
}
