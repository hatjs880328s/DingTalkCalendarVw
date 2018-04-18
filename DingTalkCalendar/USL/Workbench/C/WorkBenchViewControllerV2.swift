//
//  WorkBenchViewControllerV2.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/16.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import UIKit

class WorkBenchViewControllerV2: UIViewController {

    let topView: WorkBenchTopVw = WorkBenchTopVw(frame: CGRect.zero)
    
    let botVw: WorkBenchBotTbVw = WorkBenchBotTbVw(frame: CGRect.zero)
    
    let bannerVw: WorkBenchBannerVw = WorkBenchBannerVw(frame: CGRect.zero)
    
    let weekDayVw: DingTalkCalenderWeekdayView = DingTalkCalenderWeekdayView(frame: CGRect.zero)
    
    let calendarVw: BigDingTalkSingleLineCollectionVw = BigDingTalkSingleLineCollectionVw(frame: CGRect.zero)
    
    let smallCalendarVw: SmallDingTalkSingleLineCollectionVw =  SmallDingTalkSingleLineCollectionVw(frame: CGRect.zero)
    
    let vm = DingTalkCalanderVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APPDelStatic.lightGray
        self.navigationController?.isNavigationBarHidden = true
        
        createTopView()
        createBannerVw()
        createWeekDay()
        createCalendarVw()
        createSmallCalendarVw()
        createBotTBVw()
        
        getMiddleDate()
        getSmallCalendarDate()
        hiddenMiddleCalendarVw()
    }

}

// MARK: - top-view & bot tb-view & calendar vw
extension WorkBenchViewControllerV2 {
    /// top vw
    func createTopView() {
        self.topView.createView(fatherView: self.view)
    }
    
    /// banner vw
    func createBannerVw() {
        self.bannerVw.createVw(with: self.view, top: self.topView)
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
    func hiddenMiddleCalendarVw() {
        self.botVw.swipeUp()
        self.smallCalendarVw.alpha = 1
    }
    
    // show middle vw [swipe down][invoking big calendar vw create 2 others vw once]
    func showMiddleCalcendarVw() {
        self.calendarVw.createOther2ChildVw()
        self.botVw.swipeDown()
        self.smallCalendarVw.alpha = 0
    }
    
    /// small calendar hor swipe - big calendar dates change
    func smallCalendarSwipeHor() {
        self.calendarVw.setDates(with: self.vm.getDingVModel(with: .middle).trupleVM!.dayArr, which: self.calendarVw.middleChildVw)
        if self.calendarVw.leftChildVw == nil { return }
        self.calendarVw.setDates(with: self.vm.getDingVModel(with: .left).trupleVM!.dayArr, which: self.calendarVw.leftChildVw)
        self.calendarVw.setDates(with: self.vm.getDingVModel(with: .right).trupleVM!.dayArr, which: self.calendarVw.rightChildVw)
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
        self.vm.getCurrentline7Days()
        self.smallCalendarVw.setDates(date: self.vm.smallMiddleDate, position: .middle)
        self.smallCalendarVw.setDates(date: self.vm.smallLeftDate, position: .left)
        self.smallCalendarVw.setDates(date: self.vm.smallRightDate, position: .right)
    }
}
