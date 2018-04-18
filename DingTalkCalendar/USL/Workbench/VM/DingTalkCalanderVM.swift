//
//  DingTalkCalanderVM.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/12.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import EventKit

typealias dingTalkTrupleViewModel = (dayArr: [DingTalkCalanderVModel],headerCount:Int,footerCount:Int)

enum ModelPosition: String {
    case middle
    case left
    case right
}

enum UIState: String {
    case single
    case all
}

class DingTalkCalanderVM: NSObject {
    
    /// big pic cache
    var savedDingVMModel: [dingTalkTrupleKey:dingTalkTrupleModel] = [:]
    
    /// small pic cache
    var savedDingLineVMModel: [dingTalkTrupleKey:DingTalkCalendarTrupleVModel] = [:]
    
    var workBench: IWorkBench!
    
    /// big pic parameters
    
    var rightDate: dingTalkTrupleModel!
    
    var middleDate: dingTalkTrupleModel!
    
    var leftDate: dingTalkTrupleModel!
    
    var middleVMDate: DingTalkCalendarTrupleVModel!
    
    var leftVMDate: DingTalkCalendarTrupleVModel!
    
    var rightVMDate: DingTalkCalendarTrupleVModel!
    
    /// small pic parameters
    
    var smallMiddleDate: [DingTalkCalanderVModel]!
    
    var smallLeftDate: [DingTalkCalanderVModel]!
    
    var smallRightDate: [DingTalkCalanderVModel]!
    
    // events & state
    
    var eventCalendarIns: IWorkBenchEventCalendar!
    
    /// swipe - change topvw text closure
    var swipeChangeTopTitleTxt: ((_ txt: String)->Void)!
    
    override init() {
        super.init()
        self.workBench = BeanFactory().create(with: "workBenchIns") as! IWorkBench
        self.eventCalendarIns = BeanFactory().create(with: "workEventCalendarIns") as! IWorkBenchEventCalendar
    }
    
    /// follow postition return dingVm
    func getDingVModel(with position: ModelPosition)->DingTalkCalendarTrupleVModel {
        switch position {
        case .left:
            return leftVMDate
        case .right:
            return rightVMDate
        case .middle:
            return middleVMDate
        }
    }
    
    // MARK: - get dates info
    func changeDingModelToDingVM(left:dingTalkTrupleModel,middle: dingTalkTrupleModel,right:dingTalkTrupleModel)->(left:dingTalkTrupleViewModel,middle: dingTalkTrupleViewModel,right:dingTalkTrupleViewModel){
        let leftResult = changeTrupleModelToTrupleVModel(model: left)
        self.leftDate = left
        self.leftVMDate = DingTalkCalendarTrupleVModel(with: leftResult)
        let middleResult = changeTrupleModelToTrupleVModel(model: middle)
        self.middleDate = middle
        self.middleVMDate = DingTalkCalendarTrupleVModel(with: middleResult)
        let rightResult = changeTrupleModelToTrupleVModel(model: right)
        self.rightDate = right
        self.rightVMDate = DingTalkCalendarTrupleVModel(with: rightResult)
        
        return (leftResult,middleResult,rightResult)
    }
    
    /// first get dateinfo
    @discardableResult
    func getCurrentMonthDays(currentMonthDay: Date)->(left:dingTalkTrupleViewModel,middle: dingTalkTrupleViewModel,right:dingTalkTrupleViewModel) {
        //middle
        let currentMiddleInfo: dingTalkTrupleModel = self.workBench.getDate(position: .middle, middleDates: nil,middleFollowDate: currentMonthDay)
        let middleKey = workBench.getDicKey(with: currentMiddleInfo)
        self.savedDingVMModel[middleKey] = currentMiddleInfo
        //right
        let rightInfo = self.workBench.getDate(position: .right, middleDates: currentMiddleInfo,middleFollowDate: nil)
        let rightKey = self.workBench.getDicKey(with: rightInfo)
        self.savedDingVMModel[rightKey] = rightInfo
        //left
        let leftInfo = self.workBench.getDate(position: .left, middleDates: currentMiddleInfo,middleFollowDate: nil)
        let leftKey = self.workBench.getDicKey(with: leftInfo)
        self.savedDingVMModel[leftKey] = leftInfo
        
        return self.changeDingModelToDingVM(left: leftInfo, middle: currentMiddleInfo, right: rightInfo)
    }
    
    /// change truple model - truple vmodel
    private func changeTrupleModelToTrupleVModel(model: dingTalkTrupleModel)->dingTalkTrupleViewModel {
        var resultDVMArr = [DingTalkCalanderVModel]()
        for eachItem in model.dayArr {
            let eachDingVM = DingTalkCalanderVModel(with: eachItem)
            resultDVMArr.append(eachDingVM)
        }
        let vmResult = (resultDVMArr,model.headerCount,model.footerCount)
        
        return vmResult
    }
    
    
}

// MARK: - global queue progress events
extension DingTalkCalanderVM {
    
    func getCurrentPicFirstDayAndLastDay(dateInfo: dingTalkTrupleViewModel)->(startDate: Date,endDate: Date)? {
        if dateInfo.dayArr.count == 0 { return nil }
        
        return (dateInfo.dayArr.first!.dateInfo,dateInfo.dayArr.last!.dateInfo)
    }
    
    /// from calendar get events
    func getEventDate(with currentPicDate: dingTalkTrupleViewModel,action: @escaping ()->Void) {
        let dateArr = self.getCurrentPicFirstDayAndLastDay(dateInfo: currentPicDate)
        if dateArr == nil { return }
        self.eventCalendarIns.getEventsInGlobalQueue(from: dateArr!.startDate, to: dateArr!.endDate) { (events) in
            for eachItem in events {
                GCDUtils.asyncProgress(dispatchLevel: 1, asyncDispathchFunc: {
                    let dingTalkEvent = DingTalkCEvent(with: eachItem)
                    eventsLoop:for eachItemVM in currentPicDate.dayArr {
                        if eachItem.startDate.days == eachItemVM.dateInfo.days && eachItem.startDate.month == eachItemVM.dateInfo.month {
                            eachItemVM.setEventDay(with: dingTalkEvent)
                            break eventsLoop
                        }
                    }
                }, endMainDispatchFunc: {
                    action()
                })
            }
        }
    }
}

// MARK: - swipe left right & up down BIG VW
extension DingTalkCalanderVM {
    
    /// when small calendar vw swipe hor - big calendar vw dates should change also [true: should change false: shouldn't]
    @discardableResult
    func smallCalendarCollectionSwipeChangeBigDates(withDate: Date)->Bool {
        let progressDate = withDate.dateFormate("yyyy-MM-dd")
        if progressDate.month == self.middleDate.dayArr[self.middleDate.headerCount].dateInfo.month { return false }
        self.getCurrentMonthDays(currentMonthDay: progressDate)
        return true
    }
    
    /// swipe to left [vm progress date]
    func swipeLeft()->dingTalkTrupleViewModel {
        //change date
        self.leftDate = self.middleDate
        self.middleDate = self.rightDate
        //get right new date info
        let newRightMonthFirstDate = workBench.getAfterMonthFirstDay(with: middleDate)
        let cacheKey = workBench.getDicKey(with: newRightMonthFirstDate)
        if self.savedDingVMModel[cacheKey] != nil {
            self.rightDate = self.savedDingVMModel[cacheKey]
        }else{
            let newRightDate = workBench.getDate(position: DingTalkPosition.right, middleDates: self.middleDate,middleFollowDate: nil)
            self.rightDate = newRightDate
        }
        //change top txt
        swipeChangeTopVwTxt(dateInfo: middleDate)
        
        
        return self.changeTrupleModelToTrupleVModel(model: self.rightDate)
    }
    
    /// swipe to right [vm progress date]
    func swipeRight()->dingTalkTrupleViewModel {
        //change date
        self.rightDate = self.middleDate
        self.middleDate = self.leftDate
        //get left new date info
        let newLeftMonthLastDate = workBench.getBeforeMonthLastDay(with: middleDate)
        let cacheKey = workBench.getDicKey(with: newLeftMonthLastDate)
        if self.savedDingVMModel[cacheKey] != nil {
            self.leftDate = self.savedDingVMModel[cacheKey]
        }else{
            let newLeftDate = workBench.getDate(position: DingTalkPosition.left, middleDates: self.middleDate,middleFollowDate: nil)
            self.leftDate = newLeftDate
        }
        //change top txt
        swipeChangeTopVwTxt(dateInfo: middleDate)
        
        return self.changeTrupleModelToTrupleVModel(model: self.leftDate)
    }
    
    /// swipe - change topvw text closure
    private func swipeChangeTopVwTxt(dateInfo: dingTalkTrupleModel) {
        if self.swipeChangeTopTitleTxt == nil { return }
        let realDate = dateInfo.dayArr[dateInfo.headerCount].dateInfo
        if realDate == nil { self.swipeChangeTopTitleTxt("") }
        let txt: String = "\(realDate!.year)年\(realDate!.month)月"
        self.swipeChangeTopTitleTxt(txt)
    }
    
    /// get selected item in which line [ 1 ~ 6 ]
    func getLineNumWithVModel(dates: DingTalkCalenderView)->Int {
        let selectedItem = dates.beSelectedTag
        return selectedItem/7 + 1
    }
    
    /// get selected item in which line [1 - 6]
    func getLineNumberWithTrupleModel(position: ModelPosition)->Int {
        switch position {
        case .left:
            return self.leftVMDate.beSelectedTag / 7 + 1
        case .middle:
            return self.middleVMDate.beSelectedTag / 7 + 1
        case .right:
            return self.rightVMDate.beSelectedTag / 7 + 1
        }
    }
    
}

// MARK: - swipe left & right SMALL VW
extension DingTalkCalanderVM {
    
    private func getDistanceFirstDayIntValueByWeekDay(with strInfo: String)->(distanceFist: Int,distanceLast: Int) {
        if strInfo == "日" {
            return (0,6)
        }
        if strInfo == "一" {
            return (1,5)
        }
        if strInfo == "二" {
            return (2,4)
        }
        if strInfo == "三" {
            return (3,3)
        }
        if strInfo == "四" {
            return (4,2)
        }
        if strInfo == "五" {
            return (5,1)
        }
        if strInfo == "六" {
            return (6,0)
        }
        return (0,0)
    }
    
    /// get line firstday & lastday follow current-month selected day
    private func getTheLineFirstDayAndLastDay()->(lineFistDay: Date,lineLastDay: Date) {
        let selectedDay = self.middleVMDate.trupleVM.dayArr[self.middleVMDate.beSelectedTag - 1]
        let itemDay = selectedDay.dateInfo.week
        let distanceFirstDay = self.getDistanceFirstDayIntValueByWeekDay(with: itemDay)
        let lineFirstDay = selectedDay.dateInfo.beforeDate(distanceFirstDay.distanceFist)
        let lineLastDay = selectedDay.dateInfo.nextDate(distanceFirstDay.distanceLast)
        
        return (lineFirstDay,lineLastDay)
    }
    
    /// get left & middle & right modelArr by big middle dates
    func getCurrentline7Days() {
        let trupleInfo = self.getTheLineFirstDayAndLastDay()
        let firstDay = trupleInfo.lineFistDay
        let lastDay = trupleInfo.lineLastDay
        
        let models =  workBench.get7Days(with: firstDay.beforeDate(1), is: true)
        var results = [DingTalkCalanderVModel]()
        for eachItem in models {
            let ins = DingTalkCalanderVModel(with: eachItem)
            results.append(ins)
        }
        self.smallMiddleDate = results
        
        let leftModels = workBench.get7Days(with: firstDay, is: false)
        var leftResults = [DingTalkCalanderVModel]()
        for eachItem in leftModels {
            let ins = DingTalkCalanderVModel(with: eachItem)
            leftResults.append(ins)
        }
        self.smallLeftDate = leftResults
        
        let rightModels = workBench.get7Days(with: lastDay, is: true)
        var rightResults = [DingTalkCalanderVModel]()
        for eachItem in rightModels {
            let ins = DingTalkCalanderVModel(with: eachItem)
            rightResults.append(ins)
        }
        self.smallRightDate = rightResults
    }
    
    /// swipe left - get new right dates
    func smallSwipeleft()->[DingTalkCalanderVModel] {
        // logic dates change
        self.smallLeftDate = self.smallMiddleDate
        self.smallMiddleDate = self.smallRightDate
        
        
        let lastDay = self.smallRightDate[6].dateInfo!
        let models =  workBench.get7Days(with: lastDay, is: true)
        var results = [DingTalkCalanderVModel]()
        for eachItem in models {
            let ins = DingTalkCalanderVModel(with: eachItem)
            results.append(ins)
        }
        self.smallRightDate = results
        self.smallCalendarCollectionSwipeChangeBigDates(withDate: self.smallMiddleDate[0].dateInfo)
        
        return results
    }
    
    /// swipe right - get new left dates
    func smallSwipeRight()->[DingTalkCalanderVModel] {
        // logic dates change
        self.smallRightDate = self.smallMiddleDate
        self.smallMiddleDate = self.smallLeftDate
       
        
        let lastDay = self.smallLeftDate[0].dateInfo!
        let models =  workBench.get7Days(with: lastDay, is: false)
        var results = [DingTalkCalanderVModel]()
        for eachItem in models {
            let ins = DingTalkCalanderVModel(with: eachItem)
            results.append(ins)
        }
        self.smallLeftDate = results
        self.smallCalendarCollectionSwipeChangeBigDates(withDate: self.smallMiddleDate[0].dateInfo)
        
        return results
    }
    
    
}
