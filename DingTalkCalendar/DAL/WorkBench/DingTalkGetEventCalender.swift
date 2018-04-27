//
//  DingTalkGetEventCalender.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/14.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import EventKit


class DingTalkGetEventCalender: NSObject {
    
    var eventDB: EKEventStore!
    
    override init() {
        super.init()
        self.connectTheEventDB()
    }
    
    private func connectTheEventDB() {
         self.eventDB = EKEventStore()
    }
    
    /// get events from datea ~ dateb
    func getEventFromEventDB(eventType: EKEntityType = EKEntityType.event,startTime: Date,endTime: Date,resultAction: @escaping (_ event: [EKEvent]?)->Void) {
        if self.eventDB == nil { return }
        self.eventDB.requestAccess(to: eventType) { (flag, errorInfo) in
            if errorInfo != nil { return }
            if !flag { return }
            let calender = self.eventDB.calendars(for: eventType)
            let predicate = self.eventDB.predicateForEvents(withStart: startTime, end: endTime, calendars: calender)
            let eVArr = self.eventDB.events(matching: predicate)
            resultAction(eVArr)
        }
    }
    
    /// set event to calendar
    func addEvents(with ekEvent: EKEvent,successAction: @escaping ()->Void,failAction:@escaping ()->Void) {
        self.eventDB.requestAccess(to: EKEntityType.event) { [weak self](isOk, errors) in
            if errors == nil && isOk && self != nil {
                do {
                    ekEvent.calendar = self!.eventDB.defaultCalendarForNewEvents
                    try self!.eventDB.save(ekEvent, span: EKSpan.thisEvent)
                    successAction()
                }catch{
                    failAction()
                }
            }
        }
    }
}
