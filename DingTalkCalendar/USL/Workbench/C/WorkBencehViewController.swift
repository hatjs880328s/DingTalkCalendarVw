//
//  WorkBencehViewController.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/12.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import UIKit

@objc class WorkBencehViewController: UIViewController {

    let vm = DingTalkCalanderVM()
    
    let calendarVw = DingTalkCalanderCollectionView(frame: CGRect.zero)
    
    let topView: WorkBenchTopVw = WorkBenchTopVw(frame: CGRect.zero)
    
    let botVw: WorkBenchBotTbVw = WorkBenchBotTbVw(frame: CGRect.zero)
    
    let bannerVw: WorkBenchBannerVw = WorkBenchBannerVw(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = APPDelStatic.lightGray
        self.navigationController?.isNavigationBarHidden = true
            
        createTopView()
        createBannerVw()
        createDingTalkCalender()
        createBotTBVw()
        
        swipeAction()
        getTodayEvents()
    }
    
    deinit {
        print("ding_talk_vc_deinit")
    }
}

// MARK: - top-view & bot tb-view
extension WorkBencehViewController {
    /// top vw
    func createTopView() {
        self.topView.createView(fatherView: self.view)
        
    }
    
    /// banner vw
    func createBannerVw() {
        self.bannerVw.createVw(with: self.view, top: self.topView)
    }
    
    /// bottbvw
    func createBotTBVw() {
        botVw.createVw(topView: calendarVw, fatherView: self.view)
    }
    
    
}

// MARK: - calendar view
extension WorkBencehViewController {
    
    /// create calendar view
    func createDingTalkCalender() {
        calendarVw.initDTCView(with: self.view,topView: self.bannerVw)
        let currentDateTrupleInfo = self.vm.getCurrentMonthDays()
        calendarVw.create3ChildView(leftDate: currentDateTrupleInfo.left, rightDate: currentDateTrupleInfo.right, middleDate: currentDateTrupleInfo.middle)
        calendarVw.swipeGetDateInfo = {[weak self]dirction in
            if dirction == UISwipeGestureRecognizerDirection.left {
                return self?.vm.swipeLeft()
            }else{
                return self?.vm.swipeRight()
            }
        }
    }
}

// MARK: - ui-action
extension WorkBencehViewController {
    
    func reloadTb() {
        self.botVw.tabVw.reloadData()
    }
}

// MARK: - vm actions [today-events]
extension WorkBencehViewController {
    
    func getTodayEvents() {
        self.vm.getEventDate(with: self.calendarVw.logicMiddleVw.dateInfo) { [weak self]() in
            self?.calendarVw.setEvents()
            self?.reloadTb()
        }
    }
    
    func swipeAction() {
        self.vm.swipeChangeTopTitleTxt = { [weak self]txt in
            self?.topView.setData(ifCalendar: true, titleTxt: txt)
        }
    }
}
