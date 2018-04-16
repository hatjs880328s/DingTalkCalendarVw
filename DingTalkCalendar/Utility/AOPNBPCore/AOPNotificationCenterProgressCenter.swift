//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPNotificationCenterProgressCenter.swift
//
// Created by    Noah Shan on 2018/3/14
// InspurEmail   shanwzh@inspur.com
// GithubAddress https://github.com/hatjs880328s
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// For the full copyright and license information, plz view the LICENSE(open source)
// File that was distributed with this source code.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
//
import UIKit
import Foundation


/// progress userinfo tool
class AOPNotificationCenterProgressCenter : NSObject {
    
    var userinfo : [AnyHashable: Any] = [: ]
    
    init(userinfo : [AnyHashable: Any]?) {
        super.init()
        if userinfo != nil {
            self.userinfo = userinfo!
        }
    }
    
    func progressUserinfo() {}
    
    func insertIntoMemCacheList(item: GodfatherEvent) {
        AOPMemCacheV20.getInstance().addOneItemFromNotificationCenter(item: item)
    }
    
    func alertInfo(realInfo: GodfatherEvent) {
        @discardableResult
        func showAlert()->Bool {
            let alert = UIAlertView(title: "AOPCore", message: realInfo.sourceName + realInfo.triggerDate!.description, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return true
        }
        
        //assert(showAlert())
    }
}

class TBProgress: AOPNotificationCenterProgressCenter {
    override func progressUserinfo() {
        let realInfo = (super.userinfo[AOPEventType.tbselectedAction] as! TBEvent)
        self.insertIntoMemCacheList(item: realInfo)
        self.alertInfo(realInfo: realInfo)
    }
}

class VCProgress: AOPNotificationCenterProgressCenter {
    override func progressUserinfo() {
        let realInfo = (super.userinfo[AOPEventType.vceventAction] as! VCEvent)
        self.insertIntoMemCacheList(item: realInfo)
        self.alertInfo(realInfo: realInfo)
    }
}

class APPProgress: AOPNotificationCenterProgressCenter {
    override func progressUserinfo() {
        let realInfo = (super.userinfo[AOPEventType.applicationSendaction] as! SendActionEvent)
        self.insertIntoMemCacheList(item: realInfo)
        self.alertInfo(realInfo: realInfo)
    }
}

/// progress tool factory
class AOPProgressCenterFactory : NSObject {
    func concreateIns(userinfo: [AnyHashable: Any])->AOPNotificationCenterProgressCenter {
        let eventType: String = "\(userinfo.first!.key)"
        switch eventType {
        case AOPEventType.tbselectedAction.rawValue:
            return TBProgress(userinfo: userinfo)
        case AOPEventType.applicationSendaction.rawValue:
            return APPProgress(userinfo: userinfo)
        case AOPEventType.vceventAction.rawValue:
            return VCProgress(userinfo: userinfo)
        default:
            return AOPNotificationCenterProgressCenter(userinfo: [:])
        }
    }
}
