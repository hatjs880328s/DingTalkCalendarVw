//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPCoreExtension.swift
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

// 
import Foundation

/// event type (1 lvl)
enum AOPEventType:String {
    case tbselectedAction
    case vceventAction
    case applicationSendaction
}

/// viewcontroller event type (2 lvl)
enum VCEventType: String {
    case didappear
    case diddisappear
}

/// controlEvent type (2 lvl)
enum ControlEventType: String {
    case uibutton
    // sys navigation bar button
    case uibuttonbarbutton
    // navigationcontroller - pop viewcontroller
    case navigationVCPop
}

// MARK: - event notification name
extension Notification.Name {
    struct InspurNotifications {
        /// tableview-didselect-sendaction
        var tbDidSelectedAction = Notification.Name(AOPEventType.tbselectedAction.rawValue)
        /// viewcontroller-viewdidappear
        var vceventAction = Notification.Name(AOPEventType.vceventAction.rawValue)
        /// app-sendaction
        var appSendActions = Notification.Name(AOPEventType.applicationSendaction.rawValue)
    }
}


