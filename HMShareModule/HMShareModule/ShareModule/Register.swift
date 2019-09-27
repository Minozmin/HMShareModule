//
//  Register.swift
//  ShareModule
//
//  Created by Hehuimin on 2019/3/29.
//  Copyright © 2019 Hehuimin. All rights reserved.
//

import Foundation

public class Register {
    private var tencentOauth: TencentOAuth!
    
    // 注册微信
    public func setupWechat(appId: String) {
        WXApi.registerApp(appId)
    }
    
    // 注册QQ
    public func setupQQ(appId: String) {
        tencentOauth = TencentOAuth.init(appId: appId, andDelegate: self as? TencentSessionDelegate)
    }
    
    // 注册微博
    public func setupWeibo(appKey: String) {
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(appKey)
    }
}
