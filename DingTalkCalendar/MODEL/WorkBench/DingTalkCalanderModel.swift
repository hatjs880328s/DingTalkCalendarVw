//
//  DingTalkCalanderModel.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/12.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class DingTalkCalanderModel: NSObject {
    
    var gregorionDay: Int = 0
    
    var weekDay: Int = 0
    
    var lunarDay: Int = 0
    
    var isFireDay: Bool = false
    
    var fireDayInfo: [String] = []
    
    var isCurrentDay: Bool = false
    
    var isFirstDayCurrentMonth:Bool = false
    
    var isRestDay: DayType = .normal
    
    var isCurrentMonthDay: Bool = false
    
    var dateInfo:Date! {
        didSet{
            //progress lunarDay
            if dateInfo != nil {
                self.lunarDay = dateInfo.getLunarDayInfo()
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    func setParameters(gregorionDay:Int,weekDay:Int,
                       lunarDay:Int,isCurrentDay:Bool,
                       isFirstDayCurrentMonty:Bool,
                       dateInfo:Date,isCurrentMonthDay:Bool) {
        self.gregorionDay = gregorionDay
        self.lunarDay = lunarDay
        self.weekDay = weekDay
        self.isCurrentDay = isCurrentDay
        self.isFirstDayCurrentMonth = isFirstDayCurrentMonty
        self.dateInfo = dateInfo
        self.isCurrentMonthDay  = isCurrentMonthDay
    }
    
    func setFireInfo(isFireDay:Bool,fireDayInfo:[String],isRestDay:DayType){
        self.isFireDay = isFireDay
        self.fireDayInfo = fireDayInfo
        self.isRestDay = isRestDay
    }
    
    
    
    
}
