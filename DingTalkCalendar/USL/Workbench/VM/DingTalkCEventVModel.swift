//
//  DingTalkCEventVModel.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/14.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import EventKit

class DingTalkCEvent: NSObject {
    
    var startTime: String = ""
    
    var endTime: String = ""
    
    var title: String = ""
    
    var subTitle: String = "来自手机日历"
    
    var modelType: EKCalendarType!
    
    var realStartTime: String = ""
    
    var realEndTime: String = ""
    
    var id: String = ""
    
    /// create dingtalkEvent manual
    var isAllDay:Bool = false
    
    /// create dingtalkEvent manual [sec]
    var relativeOffset:TimeInterval = 0
    
    let formatStrHM = "HH:mm"
    
    let normalFormatStr = "yyyy-MM-dd HH:mm:ss"
    
    let formatFullStr = "yyyy-MM-dd HH:mm"
    
    let todayStr = "全天"
    
    init(with kevent: EKEvent){
        super.init()
        self.setDate(with: kevent)
    }
    
    /// change self to EKEvent
    override init() {
        super.init()
    }
    
    /// create dingtalk model
    public func createDingTalkEventManual(startTime: Date,endTime: Date,title: String,isAllDay:Bool,relativeOffset:TimeInterval) {
        self.realStartTime = startTime.dateToString(formatFullStr)
        self.realEndTime = endTime.dateToString(formatFullStr)
        self.isAllDay = isAllDay
        self.title = title
        self.relativeOffset = relativeOffset
    }
    
    private func setDate(with kevent: EKEvent) {
        self.id = kevent.eventIdentifier
        if !kevent.isAllDay {
            self.startTime = kevent.startDate.dateToString(formatStrHM)
            self.endTime = kevent.endDate.dateToString(formatStrHM)
        }else{
            self.startTime = todayStr
        }
        self.modelType = kevent.calendar.type
        self.title = kevent.title
        realStartTime = kevent.startDate.dateToString(normalFormatStr)
        realEndTime = kevent.endDate.dateToString(normalFormatStr)
    }
    
    func descriptions()->String {
        return "title is \(self.title),subtitle is \(self.subTitle),startTime is \(self.startTime),endTime is \(self.endTime),realStartTime is \(realStartTime),realEndTime is \(realEndTime)"
    }
    
    static func ==(fis: DingTalkCEvent,scs: DingTalkCEvent)->Bool {
        return fis.id == scs.id
    }
    
}
