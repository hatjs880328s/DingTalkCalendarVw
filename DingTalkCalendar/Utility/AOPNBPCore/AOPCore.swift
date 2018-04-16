//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// shanGo.swift
//
// Created by    Noah Shan on 2018/3/13
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
import Aspects

/*
 non-buried point(NBP) SDK : AOP layer
 collect sys event & post notification to NotificationCenter
 */

class GodfatherSwizzingPostnotification: NSObject {
    class func postNotification(notiName: Notification.Name,userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: notiName, object: nil, userInfo: userInfo)
    }
}

class GodfatherSwizzing: NSObject {
    
    static let sourceJoinedCharacter: String = "-"
    
    func aopFunction() {}
}

class TABLESwizzing: GodfatherSwizzing {
    /// tb-celldid-deselected
    let tbDidselectedBlock: @convention(block) (_ id: AspectInfo)->Void = {aspectInfo in
        let event = AOPEventFilter.tbFilter(aspectInfo: aspectInfo)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().tbDidSelectedAction, userInfo: [AOPEventType.tbselectedAction:event])
    }
    
    /// tab-celldeselected
    override func aopFunction() {
        do {
            try UITableView.aspect_hook(#selector(UITableView.deselectRow(at:animated:)),
                                        with: .init(rawValue:0),
                                        usingBlock: tbDidselectedBlock)
        }catch {}
    }
}

class VCSwizzing: GodfatherSwizzing {
    /// vc-viewdidappear
    let viewdidAppearBlock: @convention(block) (_ id : AspectInfo)->Void = { aspectInfo in
        let event = AOPEventFilter.vcFilter(aspectInfo: aspectInfo, isAppear: true)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().vceventAction, userInfo: [AOPEventType.vceventAction:event])
    }
    
    /// vc-viewdiddisappear
    let viewdidDisappearBlock:@convention(block) (_ id: AspectInfo)->Void = {aspectInfo in
        let event = AOPEventFilter.vcFilter(aspectInfo: aspectInfo, isAppear: false)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().vceventAction, userInfo: [AOPEventType.vceventAction:event])
    }
    
    /// vc-viewdidappear & diddisappear
    override func aopFunction() {
        do {
            try UIViewController.aspect_hook(#selector(UIViewController.viewDidAppear(_:)),
                                             with: .init(rawValue: 0),
                                             usingBlock: self.viewdidAppearBlock)
            try UIViewController.aspect_hook(#selector(UIViewController.viewDidDisappear(_:)),
                                             with: .init(rawValue:0),
                                             usingBlock: viewdidDisappearBlock)
        }catch {}
    }
}

class ApplicitonSwizzing: GodfatherSwizzing {
    /// application-sendAction
    let appSendActionBlock:@convention(block) (_ id: AspectInfo)-> Void = { aspectInfo in
        let event = AOPEventFilter.appFilter(aspectInfo: aspectInfo)
        GodfatherSwizzingPostnotification.postNotification(notiName: Notification.Name.InspurNotifications().appSendActions, userInfo: [AOPEventType.applicationSendaction:event])
    }
    
    /// navigation-pop(custom btn replace the sys navigationBar-backBtn)
    let navigationPopBlock:@convention(block) (_ id: AspectInfo)-> Void = { aspectInfo in
    }
    
    /// application sendaction
    override func aopFunction() {
        do{
            try UIControl.aspect_hook(#selector(UIControl.sendAction(_:to:for:)),
                                     with: .init(rawValue: 0),
                                     usingBlock: appSendActionBlock)
            try UINavigationController.aspect_hook(#selector(UINavigationController.popViewController(animated:)), with: .init(rawValue: 0), usingBlock: appSendActionBlock)
        }catch {}
    }
}


/// aop core manager---start service here
class AOPNBPCoreManagerCenter: NSObject {
    
    private static var shareInstance: AOPNBPCoreManagerCenter!
    
    private override init() {
        super.init()
    }
    
    static func getInstance()-> AOPNBPCoreManagerCenter {
        if shareInstance == nil {
            shareInstance = AOPNBPCoreManagerCenter()
        }
        return shareInstance
    }
    
    /// AOP-NBP-monitor-service start 
    func startService() {
        AOPNotificaitonCenter.getInstance()
        ApplicitonSwizzing().aopFunction()
        TABLESwizzing().aopFunction()
        VCSwizzing().aopFunction()
    }
}

