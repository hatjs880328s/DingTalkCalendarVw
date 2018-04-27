//
//  IWorkBenchEventCalendar.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/14.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import EventKit

protocol IWorkBenchEventCalendar {
    
    /// get evente from calendar
    ///
    /// - Parameters:
    ///   - from: date
    ///   - to: date
    ///   - mainThreadAction: eventAction[in main thread]
    func getEventsInGlobalQueue(from : Date,to: Date,mainThreadAction: @escaping (_ eventsArr: [EKEvent])->Void)
    
    /// set event
    func setEvent(with: DingTalkCEvent,successAction:@escaping ()->Void , failAction:@escaping ()->Void)
    
}
