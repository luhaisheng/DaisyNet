//
//  GetViewController.swift
//  DaisyNet
//
//  Created by mengqingzheng on 2017/10/10.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit
import Alamofire

class GetViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cacheTextView: UITextView!
    
    let urlStr = "http://api.travels.app887.com/api/Articles.action"
    let params = ["keyword" : "", "npc" : "0", "opc" : "20", "type" : "热门视频", "uid" : "2321"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DaisyNet.openResultLog = false
        /// 20s过期
        DaisyNet.cacheExpiryConfig(expiry: DaisyExpiry.seconds(20))
        /// 10s超时
        DaisyNet.timeoutIntervalForRequest(10)
        
        DaisyNet.request(urlStr, params: params).cache(true).responseCacheAndString { value in
            switch value.result {
            case .success(let string):
                
                if value.isCacheData {
                    self.cacheTextView.text = string
                } else {
                    self.textView.text = string
                }

            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func clearCache(_ sender: UIBarButtonItem) {
        DaisyNet.removeObjectCache(urlStr, params: params) { success in
            switch success {
            case true:
                self.cacheTextView.text = ""
            case false:
                print("false")
            }
        }
    }
    deinit {
        print("dealloc")
    }
}
