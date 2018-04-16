//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPEventFilter.swift
//
// Created by    Noah Shan on 2018/3/15
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
import Aspects

/*
 filter  - notificationProgressCenter use it . [collector]
 succsee - post to MEMCache Layer
 fail    - do nothing...
 */

class AOPEventFilter: NSObject {
    static let sourceJoinedCharacter: String = "-"
    
    /// tb filter
    static func tbFilter(aspectInfo: AspectInfo)->TBEvent {
        let tbEvent = TBEvent()
        
        var sourcename = String()
        if let tb  = aspectInfo.instance() as? UITableView {
            if let tbVC = tb.viewController() {
                let vcName = NSStringFromClass(object_getClass(tbVC)!)
                sourcename += vcName + GodfatherSwizzing.sourceJoinedCharacter
            }
            sourcename += NSStringFromClass(object_getClass(tb)!) + GodfatherSwizzing.sourceJoinedCharacter
        }
        
        var index = IndexPath()
        if let tbIndex = aspectInfo.arguments() {
            index = tbIndex[0] as! IndexPath
        }
        
        tbEvent.setBaseInfo(eventSourceName: sourcename, time: Date(), index: index)
        return tbEvent
    }
    
    /// vc filter
    static func vcFilter(aspectInfo: AspectInfo,isAppear: Bool)->VCEvent {
        let vcEvent = VCEvent()
        
        var sourcename = String()
        if let vc  = aspectInfo.instance() as? UIViewController {
            let vcName = NSStringFromClass(object_getClass(vc)!)
            sourcename += vcName
        }
        
        vcEvent.setBaseInfo(eventSourceName: sourcename, time: Date(),type: isAppear ? VCEventType.didappear : VCEventType.diddisappear)
        return vcEvent
    }
    
    /// uicontrol-application sendAction filter
    static func appFilter(aspectInfo: AspectInfo)-> SendActionEvent {
        let appEvent = SendActionEvent()
        var sourcename = String()
        var eventType = ControlEventType.uibutton
        let instance = aspectInfo.instance()
        
        if let tb  = instance as? UIButton {
            if let tbVC = tb.viewController() {
                let vcName = NSStringFromClass(object_getClass(tbVC)!)
                sourcename += vcName + GodfatherSwizzing.sourceJoinedCharacter
            }
            sourcename += NSStringFromClass(object_getClass(tb)!) + GodfatherSwizzing.sourceJoinedCharacter
        }else if NSStringFromClass(object_getClass(instance)!) == "_UIButtonBarButton"{
            sourcename = "UINavigationController-_UIButtonBarButton"
            eventType = .uibuttonbarbutton
        }else if (instance as? UINavigationController) != nil {
            sourcename = "UINavigationController-poptovcFunction"
            eventType = .navigationVCPop
        }else{
            sourcename = NSStringFromClass(object_getClass(instance)!)
        }
        
        appEvent.setBaseInfo(eventSourceName: sourcename, time: Date(),type: eventType)
        
        return appEvent
    }
}

