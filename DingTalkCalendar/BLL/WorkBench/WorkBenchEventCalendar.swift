//
//  WorkBenchEventCalendar.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/14.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import EventKit

class WorkBenchEventCalendar: NSObject,IWorkBenchEventCalendar {
    
    var dal = DingTalkGetEventCalender()
    
    static let formatStr = "yyyy-MM-dd"
    
    /// get evente from calendar
    ///
    /// - Parameters:
    ///   - from: date
    ///   - to: date
    ///   - mainThreadAction: eventAction[in main thread]
    func getEventsInGlobalQueue(from : Date,to: Date,mainThreadAction: @escaping (_ eventsArr: [EKEvent])->Void) {
        var eventsArrResult: [EKEvent] = []
        self.dal.getEventFromEventDB(startTime: from, endTime: to, resultAction: { (eventsArr) in
            if eventsArr != nil {
                for eachItem in eventsArr! {
                    eventsArrResult.append(eachItem)
                }
            }else{}
            mainThreadAction(eventsArrResult)
        })
    }
}
