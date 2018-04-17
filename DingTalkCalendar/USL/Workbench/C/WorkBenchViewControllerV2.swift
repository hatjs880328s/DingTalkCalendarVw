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
    
    let calendarVw: DingTalkSingleLineCalendarVw = DingTalkSingleLineCalendarVw(frame: CGRect.zero)
    
    let vm = DingTalkCalanderVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APPDelStatic.lightGray
        self.navigationController?.isNavigationBarHidden = true
        
        createTopView()
        createBannerVw()
        createWeekDay()
        createCalendarVw()
        createBotTBVw()
        
        
        getMiddleDate()
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
    
    /// create tb vw
    func createBotTBVw() {
        self.botVw.createVw(topView: calendarVw, fatherView: self.view)
    }
}

// MARK: - ui actions
extension WorkBenchViewControllerV2 {
    
    /// hide middle vw
    func hiddenMiddleCalendarVw() {
        let middleLineNumber = self.vm.getLineNumberWithTrupleModel(position: .middle)
        self.calendarVw.hideTopAndBotVw(with: middleLineNumber)
        self.vm.uiContainerState = .hidden
    }
    
    // show middle vw
    func showMiddleCalcendarVw() {
        self.calendarVw.showTopAndeBotVw()
        self.vm.uiContainerState = .show
    }
    
    func swipeLeft() {
        
    }
    
    func swipeRight(){
        
    }
}

// MARK: - calendar progress date
extension WorkBenchViewControllerV2 {
    
    func getMiddleDate() {
        /// [truple infos]
        vm.getCurrentMonthDays()
        let middleVM = self.vm.getDingVModel(with: .middle).trupleVM!
        self.calendarVw.setDates(with: middleVM.dayArr, which: calendarVw.middleChildVw)
    }
}
