//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// EventCollector.swift
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


import Foundation

/*
    super class - events
 
*/

class GodfatherEvent: NSObject {
    
    var triggerDate: String!
    
    var sourceName: String!
    
    var parametersJoinedCharacter: String = "|"
    
    var dateFormatStr: String = "yyyy-MM-dd HH:mm:ss"
    
    /// SET INFO
    ///
    /// - Parameters:
    ///   - eventSourceName: uicontrol name eg： BASEViewController\SmallBtn<uibutton>
    ///   - time: event trigger date
    open func setBaseInfo(eventSourceName: String,time: Date) {
        self.triggerDate = Date().dateToString(dateFormatStr)
        self.sourceName = eventSourceName
    }
    
    static func == (lhs: GodfatherEvent,ses: GodfatherEvent)->Bool {
        return lhs.triggerDate == ses.triggerDate && lhs.sourceName == ses.sourceName
    }
    
    deinit {
        //DEBUGPrintLog("aopevent - dealloc")
    }
}

/// viewcontroller-aop-acitons
class VCEvent: GodfatherEvent {
    
    var vceventType: VCEventType!
    
    open func setBaseInfo(eventSourceName: String, time: Date,type: VCEventType) {
        super.setBaseInfo(eventSourceName: eventSourceName, time: time)
        self.vceventType = type
    }
    
    override var description: String {
        return "[ event: " + sourceName + parametersJoinedCharacter + triggerDate.description +
            parametersJoinedCharacter + vceventType.rawValue +
        "]\n"
    }
}

/// tableview-aop-actions
class TBEvent: GodfatherEvent {
    
    var indexpath: IndexPath!
    
    open func setBaseInfo(eventSourceName: String,time: Date,index: IndexPath) {
        super.setBaseInfo(eventSourceName: eventSourceName, time: time)
        self.indexpath = index
    }
    
    override var description: String {
        return "[ event: " + sourceName + parametersJoinedCharacter + triggerDate.description +
            parametersJoinedCharacter + "(section:\(indexpath.section) row:\(indexpath.row))" +
        "]\n"
    }
}

/// uiapplication（uicontrol）-aop-sendActions
class SendActionEvent: GodfatherEvent {
    
    var controlType: ControlEventType!
    
    open func setBaseInfo(eventSourceName: String,time: Date,type: ControlEventType) {
        super.setBaseInfo(eventSourceName: eventSourceName, time: time)
        self.controlType = type
    }
    
    override var description: String {
        return "[ event: " + sourceName + parametersJoinedCharacter + triggerDate.description +
            parametersJoinedCharacter + controlType.rawValue +
        "]\n"
    }
}



