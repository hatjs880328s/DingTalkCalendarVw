//
//  DingTalkCalanderVModel.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/14.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class DingTalkCalanderVModel: NSObject {
    
    var gregorionDay: String = ""
    
    var weekDay: String = ""
    
    var lunarDay: String = ""
    
    var isFireDay: Bool = false
    
    var fireDayInfo: [DingTalkCEvent] = []
    
    var isCurrentDay: Bool = false
    
    var isFirstDayCurrentMonth:Bool = false
    
    var isRestDay: String = ""
    
    var isCurrentMonthDay: Bool = false
    
    var dateInfo:Date!
    
    var smallCalendarSingleFirstItem:Bool = false
    
    init(with dingModel: DingTalkCalanderModel) {
        super.init()
        self.gregorionDay = dingModel.gregorionDay.description
        self.weekDay = dingModel.description
        self.lunarDay = self.changeIntToLunarInfo(intValue: dingModel.lunarDay)
        self.isCurrentDay = dingModel.isCurrentDay
        self.isFirstDayCurrentMonth = dingModel.isFirstDayCurrentMonth
        self.isRestDay = getRestTypeStr(with: dingModel.isRestDay)
        self.isCurrentMonthDay = dingModel.isCurrentMonthDay
        self.dateInfo = dingModel.dateInfo
        
    }
    
    func setEventDay(with event: DingTalkCEvent){
        var ifExist = false
        for eachItem in self.fireDayInfo {
            if eachItem == event { ifExist = true }
        }
        if !ifExist { self.fireDayInfo.append(event) }
        self.isFireDay = true
    }
    
    func getRestTypeStr(with type: DayType)->String {
        switch type {
        case .normal:
            return ""
        case .rest:
            return "休"
        case .work:
            return "班"
        }
    }
    
    func changeIntToLunarInfo(intValue: Int)->String{
        if APPDelStatic.internationalProgress { return "" }
        switch intValue {
        case 1:
            return "初一"
        case 2:
            return "初二"
        case 3:
            return "初三"
        case 4:
            return "初四"
        case 5:
            return "初五"
        case 6:
            return "初六"
        case 7:
            return "初七"
        case 8:
            return "初八"
        case 9:
            return "初九"
        case 10:
            return "初十"
        case 11:
            return "十一"
        case 12:
            return "十二"
        case 13:
            return "十三"
        case 14:
            return "十四"
        case 15:
            return "十五"
        case 16:
            return "十六"
        case 17:
            return "十七"
        case 18:
            return "十八"
        case 19:
            return "十九"
        case 20:
            return "二十"
        case 21:
            return "廿一"
        case 22:
            return "廿二"
        case 23:
            return "廿三"
        case 24:
            return "廿四"
        case 25:
            return "廿五"
        case 26:
            return "廿六"
        case 27:
            return "廿七"
        case 28:
            return "廿八"
        case 29:
            return "廿九"
        case 30:
            return "三十"
        case 31:
            return "卅一"
        default:
            return ""
        }
        
    }
    
}
