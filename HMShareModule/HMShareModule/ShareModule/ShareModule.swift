//
//  ShareModule.swift
//  ShareModule
//
//  Created by Hehuimin on 2019/3/29.
//  Copyright © 2019 Hehuimin. All rights reserved.
//

import Foundation

private let kTitle = "title"
private let kContent = "content"
private let kThumbImage = "thumbImage"
private let kUrl = "url"
private let kContentType = "contentType"

public class ShareModule {
    //分享状态
    public typealias ShareStateChangedHandler = (_ state: ShareStateChanged) -> ()
    
    /// ShareModule
    ///
    /// - Parameter importHandler: 用于设置各平台注册信息
    public static func registerPlatforms(importHandler:@escaping (_ platformRegister: Register) -> ()) {
        importHandler(Register())
    }
    
    /// 分享内容
    ///
    /// - Parameters:
    ///   - channel: 分享渠道
    ///   - parameters: 分享参数
    ///   - stateHandler: 成功失败回调
    public static func share(channel: ShareChannel, parameters: Dictionary<String, Any>, stateHandler:@escaping ShareStateChangedHandler) {
        switch channel {
        case .QQ:
            shareQQNews(parameters: parameters, stateHandler: stateHandler)
        case .wxSession:
            if let type = parameters[kContentType] as? ContentType {
                switch type {
                case .wxWebpage:
                    shareWXWebpage(channel: channel, parameters: parameters, stateHandler: stateHandler)
                case .wxMiniProgram:
                    shareWXMiniProgram(parameters: parameters, stateHandler: stateHandler)
                case .wxImage:
                    shareWXImage(channel: channel, parameters: parameters, stateHandler: stateHandler)
                default:
                    break
                }
            }
        case .wxTimeline:
            if let type = parameters[kContentType] as? ContentType {
                switch type {
                case .wxWebpage:
                    shareWXWebpage(channel: channel, parameters: parameters, stateHandler: stateHandler)
                case .wxImage:
                    shareWXImage(channel: channel, parameters: parameters, stateHandler: stateHandler)
                default:
                    break
                }
            }
        case .weibo:
            if let type = parameters[kContentType] as? ContentType {
                switch type {
                case .wbWebpage:
                    shareWBWebpage(parameters: parameters, stateHandler: stateHandler)
                case .wbImage:
                    shareWBImage(parameters: parameters, stateHandler: stateHandler)
                default:
                    break
                }
            }
        }
    }
}

//MARK:微信分享
fileprivate extension ShareModule {
    //微信好友、朋友圈网页分享
    static func shareWXWebpage(channel: ShareChannel, parameters: Dictionary<String, Any>, stateHandler:@escaping ShareStateChangedHandler) {
        //WXMediaMessage
        let message = WXMediaMessage.init()
        if let title = parameters[kTitle] as? String {
            do {
                let isMatch = try title.checkSize(error: TextLengthLimitError.title, to: 512)
                if isMatch {
                    message.title = title
                }
            } catch let error {
                Sprint(error.localizedDescription)
                stateHandler(ShareStateChanged.fail)
                return
            }
        } else {
            Sprint("title is nil")
        }
        
        if let content = parameters[kContent] as? String {
            do {
                let isMatch = try content.checkSize(error: TextLengthLimitError.content, to: 1024)
                if isMatch {
                    message.description = content
                }
            } catch let error {
                Sprint(error.localizedDescription)
                stateHandler(ShareStateChanged.fail)
                return
            }
        } else {
            Sprint("desciption is nil")
        }
        
        //WXWebpageObject
        let webpageObj = WXWebpageObject.init()
        if let url = parameters[kUrl] as? String {
            do {
                let isMatch = try url.checkSize(error: TextLengthLimitError.url, to: 10 * 1024)
                if isMatch {
                    webpageObj.webpageUrl = url
                }
            } catch let error {
                Sprint(error.localizedDescription)
                stateHandler(ShareStateChanged.fail)
                return
            }
        } else {
            Sprint("webpageUrl is nil")
        }
        
        message.mediaObject = webpageObj
        
        //SendMessageToWXReq
        let req = SendMessageToWXReq.init()
        req.bText = false
        req.message = message
        if channel == ShareChannel.wxSession {
            req.scene = Int32(WXSceneSession.rawValue)
        } else {
            req.scene = Int32(WXSceneTimeline.rawValue)
        }
        
        DispatchQueue.global().async {
            if let thumbImage = parameters[kThumbImage] as? ImageConvertible {
                let zipImage = ZipImage(with: thumbImage, maxSize: 32)
                let resultImage = UIImage.init(data: zipImage.toImageData())
                message.setThumbImage(resultImage ?? UIImage())
            } else {
                Sprint("thumbImage is nil")
            }
            DispatchQueue.main.async {
                wxRequestResult(req, to: stateHandler)
            }
        }
    }
    
    //微信小程序分享
    static func shareWXMiniProgram(parameters: Dictionary<String, Any>, stateHandler:@escaping ShareStateChangedHandler) {
        //WXMediaMessage
        let message = WXMediaMessage.init()
        if let title = parameters[kTitle] as? String {
            do {
                let isMatch = try title.checkSize(error: TextLengthLimitError.title, to: 512)
                if isMatch {
                    message.title = title
                }
            } catch let error {
                Sprint(error.localizedDescription)
                stateHandler(ShareStateChanged.fail)
                return
            }
        } else {
            Sprint("title is nil")
        }
        
        if let content = parameters[kContent] as? String {
            do {
                let isMatch = try content.checkSize(error: TextLengthLimitError.content, to: 1024)
                if isMatch {
                    message.description = content
                }
            } catch let error {
                Sprint(error.localizedDescription)
                stateHandler(ShareStateChanged.fail)
                return
            }
        } else {
            Sprint("desciption is nil")
        }
        
        //WXMiniProgramObject
        let miniProgramObj = WXMiniProgramObject.init()
        if let userName = parameters["userName"] as? String, !userName.isEmpty {
            miniProgramObj.userName = userName
        } else {
            Sprint("userName is nil")
            stateHandler(ShareStateChanged.fail)
            return
        }
        
        if let path = parameters["path"] as? String {
            miniProgramObj.path = path
        } else {
            Sprint("path is nil")
        }
        
        if let webpageUrl = parameters["webpageUrl"] as? String {
            do {
                let isMatch = try webpageUrl.checkSize(error: TextLengthLimitError.url, to: 1024)
                if isMatch {
                    miniProgramObj.webpageUrl = webpageUrl
                }
            }catch let error {
                Sprint(error.localizedDescription)
                stateHandler(ShareStateChanged.fail)
                return
            }
        } else {
            Sprint("webpageUrl is nil")
        }
        
        message.mediaObject = miniProgramObj
        
        //SendMessageToWXReq
        let req = SendMessageToWXReq.init()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        
        DispatchQueue.global().async {
            if let thumbImage = parameters[kThumbImage] as? ImageConvertible {
                let zipImage = ZipImage(with: thumbImage, maxSize: 128)
                miniProgramObj.hdImageData = zipImage.toImageData()
            } else {
                Sprint("thumbImage is nil")
            }
            
            DispatchQueue.main.async {
                wxRequestResult(req, to: stateHandler)
            }
        }
    }
    
    //微信图片分享
    static func shareWXImage(channel: ShareChannel, parameters: Dictionary<String, Any>, stateHandler:@escaping ShareStateChangedHandler) {
        let imageObj = WXImageObject.init()
        
        let message = WXMediaMessage.init()
        message.mediaObject = imageObj
        
        let req = SendMessageToWXReq.init()
        req.bText = false
        req.message = message
        if channel == ShareChannel.wxSession {
            req.scene = Int32(WXSceneSession.rawValue)
        } else {
            req.scene = Int32(WXSceneTimeline.rawValue)
        }
        
        DispatchQueue.global().async {
            if let thumbImage = parameters[kThumbImage] as? ImageConvertible {
                let zipImage = ZipImage(with: thumbImage, maxSize: 25 * 1024)
                imageObj.imageData = zipImage.toImageData()
            } else {
                Sprint("thumbImage is nil")
            }
            
            DispatchQueue.main.async {
                wxRequestResult(req, to: stateHandler)
            }
        }
    }
    
    static func wxRequestResult(_ req: SendMessageToWXReq, to stateHandler:@escaping ShareStateChangedHandler) {
        let isSuccess = WXApi.send(req)
        if isSuccess {
            stateHandler(ShareStateChanged.success)
        } else {
            Sprint("微信调起失败")
            stateHandler(ShareStateChanged.fail)
        }
    }
}

//MARK:QQ分享
fileprivate extension ShareModule {
    //QQ新闻URL对象分享
    static func shareQQNews(parameters: Dictionary<String, Any>, stateHandler:@escaping ShareStateChangedHandler) {
        guard let url = parameters[kUrl] as? String else {
            Sprint("url is nil")
            stateHandler(ShareStateChanged.fail)
            return
        }
        
        guard let title = parameters[kTitle] as? String else {
            Sprint("url is nil")
            stateHandler(ShareStateChanged.fail)
            return
        }
        
        guard let content = parameters[kContent] as? String else {
            Sprint("content is nil")
            stateHandler(ShareStateChanged.fail)
            return
        }
        
        guard let thumbImage = parameters[kThumbImage] as? String else {
            Sprint("thumbImage is nil")
            stateHandler(ShareStateChanged.fail)
            return
        }
        
        let newsObj = QQApiNewsObject.object(with: URL.init(string: url), title: title, description: content, previewImageURL: URL.init(string: thumbImage))
        let req = SendMessageToQQReq.init(content: newsObj as? QQApiObject)
        let code = QQApiInterface.send(req)
        if Int(code.rawValue) == 0 {
            stateHandler(ShareStateChanged.success)
        } else {
            Sprint("QQ调起失败 code = \(code)")
            stateHandler(ShareStateChanged.fail)
        }
    }
}

//MARK:微博分享
fileprivate extension ShareModule {
    //微博web分享
    static func shareWBWebpage(parameters: Dictionary<String, Any>, stateHandler:@escaping ShareStateChangedHandler) {
        let webpage = WBWebpageObject.init()
        
        if let objectId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            webpage.objectID = objectId
        } else {
            webpage.objectID = "com.doweidu.DWDShareModule"
        }
        
        if let title = parameters[kTitle] as? String, !title.isEmpty {
            do {
                let isMatch = try title.checkSize(error: TextLengthLimitError.title, to: 1024)
                if isMatch {
                    webpage.title = title
                }
            }catch let error {
                Sprint(error.localizedDescription)
                stateHandler(ShareStateChanged.fail)
                return
            }
        } else {
            Sprint("title is nil")
            stateHandler(ShareStateChanged.fail)
            return
        }
        
        if let url = parameters[kUrl] as? String, !url.isEmpty {
            do {
                let isMatch = try url.checkSize(error: TextLengthLimitError.url, to: 255)
                if isMatch {
                    webpage.webpageUrl = url
                }
            }catch let error {
                Sprint(error.localizedDescription)
                stateHandler(ShareStateChanged.fail)
                return
            }
        } else {
            Sprint("url is nil")
            stateHandler(ShareStateChanged.fail)
            return
        }
        
        if let content = parameters[kContent] as? String {
            do {
                let isMatch = try content.checkSize(error: TextLengthLimitError.content, to: 1024)
                if isMatch {
                    webpage.description = content
                }
            }catch let error {
                Sprint(error.localizedDescription)
                stateHandler(ShareStateChanged.fail)
                return
            }
        } else {
            Sprint("content is nil")
        }
        
        let messageObj = WBMessageObject.init()
        messageObj.mediaObject = webpage
        
        let request = WBSendMessageToWeiboRequest.request(withMessage: messageObj) as? WBSendMessageToWeiboRequest
        
        DispatchQueue.global().async {
            if let thumbImage = parameters[kThumbImage] as? ImageConvertible {
                let zipImage = ZipImage(with: thumbImage, maxSize: 32)
                webpage.thumbnailData = zipImage.toImageData()
            } else {
                Sprint("thumbImage is nil")
            }
            
            DispatchQueue.main.async {
                wbRequestResult(request, to: stateHandler)
            }
        }
    }
    
    //微博图片分享
    static func shareWBImage(parameters: Dictionary<String, Any>, stateHandler:@escaping ShareStateChangedHandler) {
        let imageObj = WBImageObject.init()
        let messageObj = WBMessageObject.init()
        messageObj.imageObject = imageObj
        let request = WBSendMessageToWeiboRequest.request(withMessage: messageObj) as? WBSendMessageToWeiboRequest
        
        DispatchQueue.global().async {
            if let thumbImage = parameters[kThumbImage] as? ImageConvertible {
                let zipImage = ZipImage(with: thumbImage, maxSize: 10 * 1024)
                imageObj.imageData = zipImage.toImageData()
            } else {
                Sprint("thumbImage is nil")
            }
            
            DispatchQueue.main.async {
                wbRequestResult(request, to: stateHandler)
            }
        }
    }
    
    static func wbRequestResult(_ req: WBSendMessageToWeiboRequest?, to stateHandler:@escaping ShareStateChangedHandler) {
        let isSuccess = WeiboSDK.send(req)
        if isSuccess {
            stateHandler(ShareStateChanged.success)
        } else {
            Sprint("微博调起失败")
            stateHandler(ShareStateChanged.fail)
        }
    }
}

//MARK:打印日志
func Sprint(_ message: Any...,
    file: String = #file,
    methodName: String = #function,
    lineNumber: Int = #line)
{
    let fileName = file.components(separatedBy: "/").last ?? ""
    #if PRODUCT
    var content: String = String.init(format: "<%@:%d %@> ", fileName, lineNumber, methodName)
    print(message, to: &content)
    Bugtags.log(content)
    #else
    print("\(fileName):\(lineNumber) \(methodName)  \(message)")
    #endif
}
