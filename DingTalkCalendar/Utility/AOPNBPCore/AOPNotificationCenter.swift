//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPNotificationCenter.swift
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
import Foundation

/*
 <use sys notification>
 AOPBot post notification to Collector
 Notification center
 Import GodfatherEvent
 */

/// have own life circle : init , deinit
class AOPNotificaitonCenter: NSObject {
    
    private static var shareInstance: AOPNotificaitonCenter!
    
    private var notiNames: [String: Notification.Name] = [: ]
    
    private var progressIns: AOPNotificationCenterProgressCenter!
    
    /// private function 
    private override init() {
        super.init()
        addNotificationNames()
        monitorNotifications()
    }
    
    /// single instance function  : )
    ///
    /// - Returns: return the aopnotification instance
    @discardableResult
    open static func getInstance()->AOPNotificaitonCenter {
        if self.shareInstance != nil {
            return self.shareInstance
        }else{
            self.shareInstance = AOPNotificaitonCenter()
            return self.shareInstance
        }
    }
    
    /// add all notification to dic  step one
    private func addNotificationNames() {
        //tb-notification
        self.notiNames[AOPEventType.tbselectedAction.rawValue] = Notification.Name.InspurNotifications().tbDidSelectedAction
        self.notiNames[AOPEventType.vceventAction.rawValue] = Notification.Name.InspurNotifications().vceventAction
        self.notiNames[AOPEventType.applicationSendaction.rawValue] = Notification.Name.InspurNotifications().appSendActions
    }
    
    /// add all notification  step two
    private func monitorNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.progressCenter(noti:)), name: self.notiNames[AOPEventType.tbselectedAction.rawValue], object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.progressCenter(noti:)), name: self.notiNames[AOPEventType.vceventAction.rawValue], object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.progressCenter(noti:)), name: self.notiNames[AOPEventType.applicationSendaction.rawValue], object: nil)
    }
    
    /// progress & analyze notification - post them to [AOP EVENT Collector: EventCollector]
    ///
    /// - Parameter noti: notification's info
    @objc func progressCenter(noti: Notification) {
        if noti.userInfo == nil || noti.userInfo!.first == nil { return }
        
        self.progressIns = AOPProgressCenterFactory().concreateIns(userinfo: noti.userInfo!)
        self.progressIns.progressUserinfo()
    }
    
    /// remove all notifications end life circle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
