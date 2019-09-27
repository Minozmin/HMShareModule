//
//  Dictionary+Extension.swift
//  ShareModule
//
//  Created by Hehuimin on 2019/4/9.
//  Copyright © 2019 Hehuimin. All rights reserved.
//

import Foundation

//MARK:设置通用分享参数
public extension Dictionary where Key == String, Value == Any {
    /// 设置通用分享参数
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 描述信息
    ///   - thumbImage: 图片
    ///   - url: 网页路径
    ///   - contentType: 内容类型，比如微信朋友圈、微信好友等
    mutating func shareCommonParams(title: String, content: String, thumbImage: ImageConvertible, url: String, contentType: ContentType
        ) {
        updateValue(title, forKey: "title")
        updateValue(content, forKey: "content")
        updateValue(thumbImage, forKey: "thumbImage")
        updateValue(url, forKey: "url")
        updateValue(contentType, forKey: "contentType")
    }
    
    /// webpage通用参数
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 描述信息
    ///   - thumbImage: 图片
    ///   - url: 网页路径
    ///   - contentType: 内容类型，比如微信朋友圈、微信好友等
    mutating func shareWebpageParams(title: String, content: String, thumbImage: ImageConvertible, url: String, contentType: ContentType) {
        shareCommonParams(title: title, content: content, thumbImage: thumbImage, url: url, contentType: contentType)
    }
    
    /// image通用参数
    ///
    /// - Parameters:
    ///   - thumbImage: 图片
    ///   - contentType: 内容类型，比如微信朋友圈、微信好友等
    mutating func shareImageParams(thumbImage: ImageConvertible, contentType: ContentType) {
        updateValue(thumbImage, forKey: "thumbImage")
        updateValue(contentType, forKey: "contentType")
    }
}

//MARK:设置微信分享参数
public extension Dictionary where Key == String, Value == Any {    
    /// 设置微信小程序分享参数
    ///
    /// - Parameters:
    ///   - title: 标题，长度不能超过512字节
    ///   - content: 描述信息，长度不能超过1K
    ///   - userName: 小程序username
    ///   - path: 小程序页面的路径
    ///   - thumbImage: 小程序新版本的预览图，大小不能超过128k
    ///   - webpageUrl: 低版本网页链接，长度不能超过1024字节
    mutating func shareWXMiniProgramParams(title: String, content: String, userName: String, path: String, thumbImage: ImageConvertible, webpageUrl: String
        ) {
        updateValue(title, forKey: "title")
        updateValue(content, forKey: "content")
        updateValue(userName, forKey: "userName")
        updateValue(webpageUrl, forKey: "webpageUrl")
        updateValue(path, forKey: "path")
        updateValue(thumbImage, forKey: "thumbImage")
        updateValue(ContentType.wxMiniProgram, forKey: "contentType")
    }
    
    /// 设置微信webpage分享参数
    ///
    /// - Parameters:
    ///   - title: 标题，长度不能超过512字节
    ///   - content: 描述信息，长度不能超过1K
    ///   - thumbImage: 图片，大小不能超过32K
    ///   - url: 网页的url地址，不能为空且长度不能超过10K
    mutating func shareWXWebpageParams(title: String, content: String, thumbImage: ImageConvertible, url: String) {
        shareCommonParams(title: title, content: content, thumbImage: thumbImage, url: url, contentType: ContentType.wxWebpage)
    }
    
    /// 设置微信image分享参数
    ///
    /// - Parameter thumbImage: 图片，大小不能超过25M
    mutating func shareWXImageParams(thumbImage: ImageConvertible) {
        shareImageParams(thumbImage: thumbImage, contentType: ContentType.wxImage)
    }
}

////MARK:设置QQ分享参数
extension Dictionary where Key == String, Value == Any {
    mutating func shareQQNewsParams(title: String, content: String, thumbImage: ImageConvertible, url: String) {
        shareCommonParams(title: title, content: content, thumbImage: thumbImage, url: url, contentType: ContentType.qq)
    }
}

//MARK:设置微博分享参数
public extension Dictionary where Key == String, Value == Any {
    /// 设置微博webpage分享参数
    ///
    /// - Parameters:
    ///   - title: 标题，不能为空且长度小于1k
    ///   - content: 描述信息，长度不能超过1K
    ///   - thumbImage: 图片，大小不能超过32K
    ///   - url: 网页的url地址，不能为空且长度不能超过255
    mutating func shareWBWebpageParams(title: String, content: String, thumbImage: ImageConvertible, url: String) {
        shareCommonParams(title: title, content: content, thumbImage: thumbImage, url: url, contentType: ContentType.wbWebpage)
    }
    
    /// 设置微博image分享参数
    ///
    /// - Parameter thumbImage: 图片，大小不能超过10M
    mutating func shareWBImageParams(thumbImage: ImageConvertible) {
        shareImageParams(thumbImage: thumbImage, contentType: ContentType.wbImage)
    }
}
