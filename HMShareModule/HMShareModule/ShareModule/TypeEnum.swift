//
//  TypeEnum.swift
//  ShareModule
//
//  Created by Hehuimin on 2019/3/29.
//  Copyright © 2019 Hehuimin. All rights reserved.
//

import Foundation

//分享渠道
public enum ShareChannel {
    case QQ            //QQ好友
    case weibo         //微博
    case wxSession     //微信好友
    case wxTimeline    //微信朋友圈
}

//分享数据类型
public enum ContentType {
    case qq                //qq
    case wxMiniProgram     //微信小程序
    case wxWebpage         //微信网页
    case wxImage           //微信图片
    case wbWebpage         //微博网页
    case wbImage           //微博图片
}

//分享状态
public enum ShareStateChanged {
    case fail         //未调起SDK
    case success      //调起SDK状态
}
