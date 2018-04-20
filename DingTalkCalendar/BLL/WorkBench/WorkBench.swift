//
//  WorkBench.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/12.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

/// calendarVw position
///
/// - middle: middle
/// - left: left
/// - right: right
enum DingTalkPosition {
    case middle
    case left
    case right
}

/// day type
///
/// - normal: normal
/// - rest: have a rest
/// - work: working.
enum DayType {
    case normal
    case rest
    case work
}

typealias dingTalkTrupleModel = (dayArr: [DingTalkCalanderModel],headerCount:Int,footerCount:Int)

typealias dingTalkTrupleKey = String

class WorkBench: NSObject,IWorkBench {
    
    let formatStr = "yyyy-MM-dd HH:mm:ss"
    
    /// get 42 days with currentMonth-one day[couldn't be current day]
    private func getCurrent42Days(with dateInfo:Date)->(dayArr: [DingTalkCalanderModel],headerCount:Int,footerCount:Int) {
        let formatDate = dateInfo
        let trupleInfo = self.getFirstDayThisMonth(formatDate.month,formatDate.year)
        let headerDays = self.getHeaderDays(with: trupleInfo.monthFirstDay)
        let footerDays = self.getFooterDays(with: trupleInfo.monthFirstDay,monthDaysCount:trupleInfo.monthCountDays,headerCout:headerDays.count)
        var resultArr = [DingTalkCalanderModel]()
        for eachItem in headerDays {
            let dingIns = DingTalkCalanderModel()
            dingIns.setParameters(gregorionDay: eachItem.days, weekDay: eachItem.weekday, lunarDay: 3, isCurrentDay: false, isFirstDayCurrentMonty: false,dateInfo: eachItem,isCurrentMonthDay: false)
            resultArr.append(dingIns)
        }
        let curentDayIndex = Date()
        for eachItem in 1 ... trupleInfo.monthCountDays {
            let day = Date.from(year: formatDate.year, month:formatDate.month, day: eachItem)!
            let dingIns = DingTalkCalanderModel()
            let isCurrentMonthFirstDay = eachItem == 1 ? true : false
            if day.days == curentDayIndex.days && day.year == curentDayIndex.year && day.month == curentDayIndex.month{
                dingIns.setParameters(gregorionDay: day.days, weekDay: day.weekday, lunarDay: 3, isCurrentDay: true, isFirstDayCurrentMonty: isCurrentMonthFirstDay,dateInfo: day,isCurrentMonthDay: true)
            }else{
                dingIns.setParameters(gregorionDay: day.days, weekDay: day.weekday, lunarDay: 3, isCurrentDay: false, isFirstDayCurrentMonty: isCurrentMonthFirstDay,dateInfo: day,isCurrentMonthDay: true)
            }
            resultArr.append(dingIns)
        }
        for eachItem in footerDays {
            let dingIns = DingTalkCalanderModel()
            dingIns.setParameters(gregorionDay: eachItem.days, weekDay: eachItem.weekday, lunarDay: 3, isCurrentDay: false, isFirstDayCurrentMonty: false,dateInfo: eachItem,isCurrentMonthDay: false)
            resultArr.append(dingIns)
        }
        
        return (resultArr,headerDays.count,footerDays.count)
    }
    
    
    /// use month & year create current monty first date
    ///
    /// - Parameters:
    ///   - month: month
    ///   - year: year
    /// - Returns: Returns: turple - monthFirstDay,monthCountDays,weedday(1 = sunday start from 1)
    func getFirstDayThisMonth(_ month:Int,_ year:Int)->(monthFirstDay: Date,monthCountDays:Int,weekDay:Int) {
        let currentDate = Date.from(year: year, month:month, day: 1)!
        let weedday:Int = currentDate.weekday
        let monthDaysCount = currentDate.numOfDayFormMouth()
        
        return (currentDate,monthDaysCount,weedday)
    }
    
    /// get currentMonth header days
    func getHeaderDays(with firstDay:Date)->[Date]{
        var shouldGetDaysCount = 0
        let weekday = firstDay.weekday
        if weekday == 1 {
            shouldGetDaysCount = 7
        }else{
            shouldGetDaysCount = weekday - 1
        }
        var resultArr = [Date]()
        for eachItem in 0 ... shouldGetDaysCount {
            if eachItem == 0 { continue }
            let dayInfo = firstDay.beforeDate(eachItem)
            resultArr.insert(dayInfo, at: 0)
        }
        
        return resultArr
    }
    
    /// get currentMonth footer days
    func getFooterDays(with firstDay:Date,monthDaysCount:Int,headerCout:Int)->[Date]{
        let shouldGetDaysCount = 42 - monthDaysCount - headerCout
        let lastDay = firstDay.nextDate(monthDaysCount - 1)
        var resultArr = [Date]()
        for eachItem in 0 ..< shouldGetDaysCount {
            resultArr.append(lastDay.nextDate(eachItem + 1))
        }
        
        return resultArr
    }
    
}


// MARK: - Get middlepic date & leftpic date & rightpic dates
extension WorkBench {
    
    /// get dates with position & middleDates
    ///
    /// - Parameters:
    ///   - position: position- middle left right
    ///   - middleDates: middleDates may be nil
    ///   - middleFollowDate: middleDates order to which day
    /// - Returns: trupleInfo
    func getDate(position: DingTalkPosition,middleDates: dingTalkTrupleModel!,middleFollowDate: Date?)->dingTalkTrupleModel {
        switch position {
        case .middle:
            return self.getMiddleDate(with: middleFollowDate!)
        case .left:
            return self.getLeftPicDate(with: middleDates.dayArr[middleDates.headerCount].dateInfo)
        case .right:
            return self.getRightDate(with: middleDates.dayArr[middleDates.headerCount].dateInfo, middlemonthDaysCount: middleDates.dayArr.count - middleDates.headerCount - middleDates.footerCount)
        }
    }
    
    /// folow dingTalkTrupleModel create a key [string]
    ///
    /// - Parameter dateInfo: dingTalkTrupleModel
    /// - Returns: str-key
    func getDicKey(with dingTalkTrupleInfo: dingTalkTrupleModel)->dingTalkTrupleKey {
        let currentMonthDay = dingTalkTrupleInfo.dayArr[dingTalkTrupleInfo.headerCount + 1].dateInfo
        if currentMonthDay == nil { return "" }
        return getDicKey(with: currentMonthDay!)
    }
    
    /// follow date create a key [string]
    ///
    /// - Parameter dateInfo: date info
    /// - Returns: str - key
    func getDicKey(with dateInfo : Date)->dingTalkTrupleKey {
        let realDateInfo = dateInfo
        return "\(realDateInfo.year)-\(realDateInfo.month)"
    }
    
    /// get after month [next month] first day
    ///
    /// - Parameter date: trupleinfo
    /// - Returns: date
    func getAfterMonthFirstDay(with date: dingTalkTrupleModel)->Date {
        return date.dayArr[date.headerCount].dateInfo.nextDate(date.dayArr.count - date.headerCount - date.footerCount)
    }
    
    /// get before month [] last day
    ///
    /// - Parameter date: truple info
    /// - Returns: date
    func getBeforeMonthLastDay(with date: dingTalkTrupleModel)->Date {
        return date.dayArr[date.headerCount].dateInfo.beforeDate(1)
    }
    
    private func getLeftPicDate(with middleMonthFirstDay:Date)->(dayArr: [DingTalkCalanderModel],headerCount:Int,footerCount:Int) {
        let leftMonthLastDay = middleMonthFirstDay.beforeDate(1)
        
        return self.getCurrent42Days(with:leftMonthLastDay)
    }
    
    private func getRightDate(with middleMonthFirstDay:Date,middlemonthDaysCount:Int)->(dayArr: [DingTalkCalanderModel],headerCount:Int,footerCount:Int) {
        let rightMonthFirstDay = middleMonthFirstDay.nextDate(middlemonthDaysCount)
        
        return self.getCurrent42Days(with: rightMonthFirstDay)
    }
    
    private func getMiddleDate(with: Date)->(dayArr: [DingTalkCalanderModel],headerCount:Int,footerCount:Int) {
        return self.getCurrent42Days(with: with)
    }
}

extension WorkBench {
    
    /// get 7 days [before or next]
    ///
    /// - Parameters:
    ///   - dateInfo: first day || last day in this line
    ///   - lastDays: true : rights ; false : left[before]
    /// - Returns: values
    func get7Days(with dateInfo: Date,is lastDays:Bool)->[DingTalkCalanderModel] {
        var results = [DingTalkCalanderModel]()
        for eachItem in 1 ... 7 {
            var day:Date!
            if lastDays {
                day = dateInfo.nextDate(eachItem)
            }else{
                day = dateInfo.beforeDate(eachItem)
            }
            let dingIns = DingTalkCalanderModel()
            let curentDayIndex = Date()
            let isCurrentMonthFirstDay = day.days == 1 ? true : false
            if day.days == curentDayIndex.days && day.year == curentDayIndex.year && day.month == curentDayIndex.month{
                dingIns.setParameters(gregorionDay: day.days, weekDay: day.weekday, lunarDay: 3, isCurrentDay: true, isFirstDayCurrentMonty: isCurrentMonthFirstDay,dateInfo: day,isCurrentMonthDay: true)
            }else{
                dingIns.setParameters(gregorionDay: day.days, weekDay: day.weekday, lunarDay: 3, isCurrentDay: false, isFirstDayCurrentMonty: isCurrentMonthFirstDay,dateInfo: day,isCurrentMonthDay: true)
            }
            if lastDays {
                results.append(dingIns)
            }else{
                results.insert(dingIns, at: 0)
            }
        }
        return results
    }
}
