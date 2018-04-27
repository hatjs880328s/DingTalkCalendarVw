//
//  IICalendarExtension.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/27.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import EventKit

extension EKEvent {
    
    /// create ekevent from dingtalkEvent
    /// relativeOffset - secs
    static func changeEventFromDingTalkEvent(with :DingTalkCEvent,store: EKEventStore) ->EKEvent {
        let event: EKEvent = EKEvent(eventStore: store)
        event.title = with.title
        event.startDate = with.realStartTime.toDate("yyyy-MM-dd HH:mm")
        event.endDate = with.realEndTime.toDate("yyyy-MM-dd HH:mm")
        event.addAlarm(EKAlarm(relativeOffset: (-with.relativeOffset)))
        event.isAllDay = with.isAllDay
        return event
    }
}
