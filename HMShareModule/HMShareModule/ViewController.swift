//
//  ViewController.swift
//  HMShareModule
//
//  Created by Hehuimin on 2019/8/2.
//  Copyright © 2019 Hehuimin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var dataArray: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        dataArray = ["QQ", "微信好友-wxWebpage", "微信朋友圈-wxWebpage", "微信好友-wxImage", "微信朋友圈-wxImage", "wxMiniProgram", "wbWebpage", "wbIamge"];
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = dataArray?[indexPath.row];
        return cell ?? UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            if ShareModule.isQQAppInstalled() {
                onQQShare()
            }
        case 1:
            if ShareModule.isWXAppInstalled() {
                onWXSessionWebpage()
            }
        case 2:
            if ShareModule.isWXAppInstalled() {
                onWXTimeLineWebpage()
            }
        case 3:
            if ShareModule.isWXAppInstalled() {
                onWXSessionImage()
            }
        case 4:
            if ShareModule.isWXAppInstalled() {
                onWXTimeLineImage()
            }
        case 5:
            if ShareModule.isWXAppInstalled() {
                onWXMiniProgram()
            }
        case 6:
            if ShareModule.isWeiboAppInstalled() {
                onWeiboWebpage()
            }
        case 7:
            if ShareModule.isWeiboAppInstalled() {
                onWeiboImage()
            }
        default:
            break
        }
    }
}

extension ViewController {
    func onQQShare() {
        var dict = [String: Any]()
        dict.shareCommonParams(title: "test", content: "this is a test data", thumbImage: "http://img2.haoshiqi.net/ma79b40a2a40fe479f0498aefc129b2a25.jpg?imageView2/0/q/70", url: "https://m.haoshiqi.net/index.html#couple_detail?__from=v2&channel_id=h5&spm=h5&pinactivitiesid=53096&channel_id=h5&spm=h5", contentType: ContentType.qq)
        ShareModule.share(channel: ShareChannel.QQ, parameters: dict) { (state) in
            
        }
    }
    
    func onWXMiniProgram() {
        var dict = [String: Any]()
        dict.shareWXMiniProgramParams(title: "test", content: "this is a test data", userName: "gh_cf81ee91e6b0", path: "", thumbImage: URL.init(string: "http://img2.haoshiqi.net/ma79b40a2a40fe479f0498aefc129b2a25.jpg?imageView2/0/q/70")!, webpageUrl: "https://m.haoshiqi.net/index.html#couple_detail?__from=v2&channel_id=h5&spm=h5&pinactivitiesid=53096&channel_id=h5&spm=h5")
        ShareModule.share(channel: ShareChannel.wxSession, parameters: dict) { (state) in
            switch state {
            case .fail:
                print("fail")
            case .success:
                print("success")
            }
        }
    }
    
    func onWXSessionWebpage() {
        var dict = [String: Any]()
        //        icon_shopCart
        //"http://img2.haoshiqi.net/ma79b40a2a40fe479f0498aefc129b2a25.jpg?imageView2/0/q/70"
        
        let image = URL.init(string: "http://img2.haoshiqi.net/ma79b40a2a40fe479f0498aefc129b2a25.jpg?imageView2/0/q/70")!
        dict.shareWXWebpageParams(title: "test", content: "this is a test data", thumbImage: image, url: "https://m.haoshiqi.net/index.html#couple_detail?__from=v2&channel_id=h5&spm=h5&pinactivitiesid=53096&channel_id=h5&spm=h5")
        ShareModule.share(channel: ShareChannel.wxSession, parameters: dict) { (state) in
            switch state {
            case .fail:
                print("fail")
            case .success:
                print("success")
            }
        }
    }
    
    func onWXTimeLineWebpage() {
        var dict = [String: Any]()
        dict.shareWXWebpageParams(title: "test", content: "this is a test data", thumbImage: "http://img2.haoshiqi.net/ma79b40a2a40fe479f0498aefc129b2a25.jpg?imageView2/0/q/70", url: "https://m.haoshiqi.net/index.html#couple_detail?__from=v2&channel_id=h5&spm=h5&pinactivitiesid=53096&channel_id=h5&spm=h5")
        ShareModule.share(channel: ShareChannel.wxTimeline, parameters: dict) { (state) in
            switch state {
            case .fail:
                print("fail")
            case .success:
                print("success")
            }
        }
    }
    
    func onWXSessionImage() {
        var dict = [String: Any]()
        dict.shareWXImageParams(thumbImage: "http://img2.haoshiqi.net/ma79b40a2a40fe479f0498aefc129b2a25.jpg?imageView2/0/q/70")
        ShareModule.share(channel: ShareChannel.wxSession, parameters: dict) { (state) in
            
        }
    }
    
    func onWXTimeLineImage() {
        var dict = [String: Any]()
        dict.shareWXImageParams(thumbImage: "http://img2.haoshiqi.net/ma79b40a2a40fe479f0498aefc129b2a25.jpg?imageView2/0/q/70")
        ShareModule.share(channel: ShareChannel.wxTimeline, parameters: dict) { (state) in
            
        }
    }
    
    func onWeiboWebpage() {
        var dict = [String: Any]()
        dict.shareWBWebpageParams(title: "test", content: "this is a test data", thumbImage: "http://img2.haoshiqi.net/ma79b40a2a40fe479f0498aefc129b2a25.jpg?imageView2/0/q/70", url: "https://m.haoshiqi.net/index.html#couple_detail?__from=v2&channel_id=h5&spm=h5&pinactivitiesid=53096&channel_id=h5&spm=h5")
        ShareModule.share(channel: ShareChannel.weibo, parameters: dict) { (state) in
            
        }
    }
    
    func onWeiboImage() {
        var dict = [String: Any]()
        dict.shareWBImageParams(thumbImage: "http://img2.haoshiqi.net/ma79b40a2a40fe479f0498aefc129b2a25.jpg?imageView2/0/q/70")
        ShareModule.share(channel: ShareChannel.weibo, parameters: dict) { (state) in
            
        }
    }
}
