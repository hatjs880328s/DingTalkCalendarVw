//
//  WorkBenchViewControllerV2.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/16.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import UIKit

class WorkBenchViewControllerV2: UIViewController {

    let topVw: WorkBenchTopVw = WorkBenchTopVw(frame: CGRect.zero)
    
    let botVw: WorkBenchBotTbVw = WorkBenchBotTbVw(frame: CGRect.zero)
    
    let bannerVw: WorkBenchBannerVw = WorkBenchBannerVw(frame: CGRect.zero)
    
    let weekDayVw: DingTalkCalenderWeekdayView = DingTalkCalenderWeekdayView(frame: CGRect.zero)
    
    let calendarVw: BigDingTalkSingleLineCollectionVw = BigDingTalkSingleLineCollectionVw(frame: CGRect.zero)
    
    let smallCalendarVw: SmallDingTalkSingleLineCollectionVw =  SmallDingTalkSingleLineCollectionVw(frame: CGRect.zero)
    
    var taskContainerVw: TaskContainerVw?
    
    let vm = DingTalkCalanderVM()
    
    let taskVM = DingtalkTaskVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = APPDelStatic.lightGray
        self.navigationController?.isNavigationBarHidden = true
        // create ui
        createTopView()
        createBannerVw()
        createWeekDay()
        createCalendarVw()
        createSmallCalendarVw()
        createBotTBVw()
        // progress data & change ui
        getMiddleDate()
        hiddenMiddleCalendarVw()
        topTxtChange()
        bannerChange()
    }

}

// MARK: - top-view & bot tb-view & calendar vw
extension WorkBenchViewControllerV2 {
    /// top vw
    func createTopView() {
        self.topVw.createView(fatherView: self.view)
    }
    
    /// banner vw
    func createBannerVw() {
        self.bannerVw.createVw(with: self.view, top: self.topVw)
    }
    
    /// weak day vw
    func createWeekDay() {
        weekDayVw.createView(added: self.view, topView: self.bannerVw)
    }
    
    /// calendar vw
    func createCalendarVw() {
        calendarVw.createView(fatherView: self.view, topView: weekDayVw)
    }
    
    /// small calendar vw
    func createSmallCalendarVw() {
        smallCalendarVw.createView(fatherView: self.view, topView: weekDayVw)
    }
    
    /// create tb vw
    func createBotTBVw() {
        self.botVw.createVw(topView: weekDayVw, fatherView: self.view)
    }
}

// MARK: - ui actions
extension WorkBenchViewControllerV2 {
    
    /// hide middle vw [swipe up]
    func hiddenMiddleCalendarVw(animated: Bool = false) {
        self.botVw.swipeUp(withAnimation:animated)
        getSmallCalendarDate()
        self.vm.uistate = .single
        self.getTodayEvents()
        self.smallCalendarVw.whenSwipeTapFistItem()
    }
    
    /// show middle vw [swipe down][invoking big calendar vw create 2 others vw once]
    func showMiddleCalcendarVw(animated: Bool = false) {
        self.calendarVw.createOther2ChildVw()
        self.botVw.swipeDown(withAnimation:animated)
        self.vm.uistate = .all
        self.getTodayEvents()
        self.calendarVw.whenSwipeTapFistItem()
    }
    
    /// small calendar hor swipe - big calendar dates change
    func smallCalendarSwipeHor() {
        self.calendarVw.setDates(with: self.vm.getDingVModel(with: .middle).trupleVM!.dayArr, which: self.calendarVw.middleChildVw)
        if self.calendarVw.leftChildVw == nil { return }
        self.calendarVw.setDates(with: self.vm.getDingVModel(with: .left).trupleVM!.dayArr, which: self.calendarVw.leftChildVw)
        self.calendarVw.setDates(with: self.vm.getDingVModel(with: .right).trupleVM!.dayArr, which: self.calendarVw.rightChildVw)
    }
    
    func topTxtChange() {
        self.vm.swipeChangeTopTitleTxt = { [weak self]text,isCurrentMonth in
            self?.topVw.setData(ifCalendar: isCurrentMonth, titleTxt: text)
        }
    }
}

// MARK: - calendar progress date
extension WorkBenchViewControllerV2 {
    
    /// big middle calendar date
    func getMiddleDate() {
        vm.getCurrentMonthDays(currentMonthDay: Date())
        let middleVM = self.vm.getDingVModel(with: .middle).trupleVM!
        self.calendarVw.setDates(with: middleVM.dayArr, which: calendarVw.middleChildVw)
    }
    
    /// small left & right calendar date
    func getSmallCalendarDate() {
        if self.vm.uistate == .single {
            self.vm.getCurrentline7Days()
        }else{
            self.vm.getCurrentline7Days(followDate: self.calendarVw.logicMiddleVw.vms[self.calendarVw.logicMiddleVw.beselectedItemIndex])
        }
        self.smallCalendarVw.setDates(date: self.vm.smallMiddleDate, position: .middle)
        self.smallCalendarVw.setDates(date: self.vm.smallLeftDate, position: .left)
        self.smallCalendarVw.setDates(date: self.vm.smallRightDate, position: .right)
    }
}

// MARK: - eventProgress
extension WorkBenchViewControllerV2 {
    
    /// get events [global queue & async]
    func getTodayEvents() {
        self.vm.getEventsFromVmDate {[weak self]() in
            if self?.vm.uistate == .all {
                self?.calendarVw.setEvents(with: self!.vm.middleVMDate.trupleVM.dayArr)
            }else{
                self?.smallCalendarVw.setEvents(with: self!.vm.smallMiddleDate)
            }
            self?.botVw.tabVw.reloadData()
        }
    }
}

// MARK: - swipe - down & up actions
extension WorkBenchViewControllerV2 {
    
    func swipeUpSelectedSamllCalendarItem(with index:Int) {
        self.smallCalendarVw.smallMiddleLogicVw.tapAction(index: index)
    }
    
    func swipeDownSelectedBigCalendarItem(with date: Date) {
        let index = self.vm.getBigItemIndexWithSamllSelectedItemIndex(with: date)
        self.calendarVw.logicMiddleVw.tapAction(index: index)
    }
}


// MARK: - Task container view init & actions
extension WorkBenchViewControllerV2 {
    
    func taskContainerVwInit() {
        self.taskContainerVw = TaskContainerVw(frame: CGRect.zero, fatherVw: self.view, topView: self.bannerVw)
        self.taskVM.getVMWithPage(page: 0)
    }
    
    /// banner index change
    func bannerChange() {
        func changeUI(with index:Int) {
            if index == 1 {
                if self.taskContainerVw == nil {
                    self.taskContainerVwInit()
                }else{
                    self.taskContainerVw?.showSelf()
                }
            }
            if index == 0 {
                self.taskContainerVw?.hideSelf()
            }
            if index == 2 {
                self.taskContainerVw?.hideSelf()
            }
        }
        
        self.bannerVw.tapAction = { index in
             changeUI(with: index)
        }
    }
}
