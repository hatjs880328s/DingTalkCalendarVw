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

class DingTalkCalanderVM: NSObject {
    
    var savedDingVMModel: [dingTalkTrupleKey:dingTalkTrupleModel] = [:]
    
    var workBench: IWorkBench!
    
    var rightDate: dingTalkTrupleModel!
    
    var middleDate: dingTalkTrupleModel!
    
    var leftDate: dingTalkTrupleModel!
    
    var eventCalendarIns: IWorkBenchEventCalendar!
    
    /// swipe - change topvw text closure
    var swipeChangeTopTitleTxt: ((_ txt: String)->Void)!
    
    override init() {
        super.init()
        self.workBench = BeanFactory().create(with: "workBenchIns") as! IWorkBench
        self.eventCalendarIns = BeanFactory().create(with: "workEventCalendarIns") as! IWorkBenchEventCalendar
    }
    
    // MARK: - get dates info
    func changeDingModelToDingVM(left:dingTalkTrupleModel,middle: dingTalkTrupleModel,right:dingTalkTrupleModel)->(left:dingTalkTrupleViewModel,middle: dingTalkTrupleViewModel,right:dingTalkTrupleViewModel){
        let leftResult = changeTrupleModelToTrupleVModel(model: left)
        self.leftDate = left
        let middleResult = changeTrupleModelToTrupleVModel(model: middle)
        self.middleDate = middle
        let rightResult = changeTrupleModelToTrupleVModel(model: right)
        self.rightDate = right
        
        return (leftResult,middleResult,rightResult)
    }
    
    /// first get dateinfo
    @discardableResult
    func getCurrentMonthDays()->(left:dingTalkTrupleViewModel,middle: dingTalkTrupleViewModel,right:dingTalkTrupleViewModel) {
        //middle
        let currentMiddleInfo: dingTalkTrupleModel = self.workBench.getDate(position: .middle, middleDates: nil,middleFollowDate: Date())
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
    
    /// swipe - change topvw text closure
    private func swipeChangeTopVwTxt(dateInfo: dingTalkTrupleModel) {
        if self.swipeChangeTopTitleTxt == nil { return }
        let realDate = dateInfo.dayArr[dateInfo.headerCount].dateInfo
        if realDate == nil { self.swipeChangeTopTitleTxt("") }
        let txt: String = "\(realDate!.year)年\(realDate!.month)月"
        self.swipeChangeTopTitleTxt(txt)
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

// MARK: - swipe left right & up down
extension DingTalkCalanderVM {
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
    
    /// get selected item in which line [ 1 ~ 6 ]
    func getLineNumWithVModel(dates: DingTalkCalenderView)->Int {
        let selectedItem = dates.beSelectedTag
        return selectedItem/7 + 1
    }
    
}
