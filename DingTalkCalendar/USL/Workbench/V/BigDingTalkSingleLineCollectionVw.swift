//
//  DingTalkSingleLineCalendarVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/16.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import UIKit

class BigDingTalkSingleLineCollectionVw: UIView {
    
    let width = UIScreen.main.bounds.width
    
    let normalDayLineHeight: CGFloat = 49
    
    var middleChildVw =  BigDingTalkSingleLineChildVw(frame: CGRect.zero)
    
    var leftChildVw: BigDingTalkSingleLineChildVw!
    
    var rightChildVw: BigDingTalkSingleLineChildVw!
    
    var logicMiddleVw: BigDingTalkSingleLineChildVw!
    
    var logicLeftVw: BigDingTalkSingleLineChildVw!
    
    var logicRightVw: BigDingTalkSingleLineChildVw!
     
    var topVw: UIView!
    
    var fatherVw: UIView!
    
    var onceUUID = NSUUID().uuidString
    
    let formatStr = "MM月dd日"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView(fatherView: UIView,topView: UIView) {
        self.topVw = topView
        self.fatherVw = fatherView
        fatherView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(normalDayLineHeight * 6)
        }
        self.addGesture(to: self)
        self.initMiddleVw()
    }
    
    /// 2 other big child view
    public func createOther2ChildVw() {
        DispatchQueue.once(withUUID: onceUUID) {
            self.leftChildVw = BigDingTalkSingleLineChildVw(frame: CGRect.zero)
            self.rightChildVw = BigDingTalkSingleLineChildVw(frame: CGRect.zero)
            self.leftChildVw.createView(fatherView: self, position: .left)
            self.rightChildVw.createView(fatherView: self,position: .right)
            
            let vmLeftDates = (self.viewController() as! WorkBenchViewControllerV2).vm.getDingVModel(with: .left).trupleVM!
            let vmRightDates = (self.viewController() as! WorkBenchViewControllerV2).vm.getDingVModel(with: .right).trupleVM!
            
            self.setDates(with: vmLeftDates.dayArr, which: self.leftChildVw)
            self.setDates(with: vmRightDates.dayArr, which: self.rightChildVw)
            
            self.logicLeftVw = self.leftChildVw
            self.logicRightVw = self.rightChildVw
        }
    }
    
    /// middle child vw init
    fileprivate func initMiddleVw() {
        self.middleChildVw.createView(fatherView: self)
        self.logicMiddleVw = self.middleChildVw
    }
    
    /// hidden self use lineNumber
    func hideTopAndBotVw(with lineNumber: Int) {
        
    }
    
    /// DingTalkCalanderModel
    func setDates(with dates: [DingTalkCalanderVModel],which vw: BigDingTalkSingleLineChildVw) {
        vw.setDates(with: dates)
    }
}


// MARK: - swipe actions
extension BigDingTalkSingleLineCollectionVw {
    
    func whenSwipeTapFistItem() {
        self.logicMiddleVw.tapAction(index: self.logicMiddleVw.firstDayItemIndex)
        self.logicLeftVw.tapAction(index: self.logicLeftVw.firstDayItemIndex)
        self.logicRightVw.tapAction(index: self.logicRightVw.firstDayItemIndex)
    }
    
    func addGesture(to dateVw: UIView) {
        let leftGsture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        leftGsture.direction = .left
        dateVw.addGestureRecognizer(leftGsture)
        let rightGsture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        rightGsture.direction = .right
        dateVw.addGestureRecognizer(rightGsture)
        let topGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeTopAction))
        topGesture.direction = .up
        dateVw.addGestureRecognizer(topGesture)
    }
    
    /// swipe left - get new right date
    @objc func swipeLeftAction() {
        // no animate
        self.logicLeftVw.frame.origin.x = self.width
        // have animate
        UIView.animate(withDuration: 0.5, animations: {
            self.logicMiddleVw.frame.origin.x = -self.width
            self.logicRightVw.frame.origin.x = 0
        }) { (completed) in
            if completed {
                // logic change
                let changeMiddleParameter = self.logicMiddleVw
                self.logicMiddleVw = self.logicRightVw
                self.logicRightVw = self.logicLeftVw
                self.logicLeftVw = changeMiddleParameter
                let newRightDate = (self.viewController() as! WorkBenchViewControllerV2).vm.swipeLeft()
                self.logicRightVw.setDates(with: newRightDate.dayArr)
                self.whenSwipeTapFistItem()
                (self.viewController() as! WorkBenchViewControllerV2).getTodayEvents()
            }
        }
    }
    
    /// swipe right - get new left date
    @objc func swipeRightAction() {
        // no animate
        self.logicRightVw.frame.origin.x = -self.width
        // have animate
        UIView.animate(withDuration: 0.5, animations: {
            self.logicLeftVw.frame.origin.x = 0
            self.logicMiddleVw.frame.origin.x = self.width
        }) { (completed) in
            if completed {
                // logic change
                let changeMiddleParameter = self.logicMiddleVw
                self.logicMiddleVw = self.logicLeftVw
                self.logicLeftVw = self.logicRightVw
                self.logicRightVw = changeMiddleParameter
                let newLeftDates = (self.viewController() as! WorkBenchViewControllerV2).vm.swipeRight()
                self.logicLeftVw.setDates(with: newLeftDates.dayArr)
                self.whenSwipeTapFistItem()
                (self.viewController() as! WorkBenchViewControllerV2).getTodayEvents()
            }
        }
    }
    
    @objc func swipeTopAction() {
        (self.viewController() as! WorkBenchViewControllerV2).hiddenMiddleCalendarVw(animated: true)
        (self.viewController() as! WorkBenchViewControllerV2).swipeUpSelectedSamllCalendarItem(with: self.logicMiddleVw.beselectedItemIndex%7)
    }
}

// MARK: - eventProgress
extension BigDingTalkSingleLineCollectionVw {
    
    //set events info with kcevent just in logicMiddlePic
    func setEvents(with: [DingTalkCalanderVModel]) {
        var resultArr = [Int: Bool]()
        let middleLogic = self.logicMiddleVw!
        GCDUtils.asyncProgress(dispatchLevel: 1, asyncDispathchFunc: {
            for eachItem in 0 ... with.count - 1 {
                if with[eachItem].isFireDay {
                    resultArr[eachItem] = true
                }
            }
        }) {
            for eachItem in resultArr {
                middleLogic.childsVwArr[eachItem.key].setEventDay()
            }
        }
    }
}

// MARK: - tb actions
extension BigDingTalkSingleLineCollectionVw {
    /// tb-[cell number]
    func getCellModelsCount()->Int {
        let selectedIndex = self.logicMiddleVw.beselectedItemIndex
        let count = (self.viewController() as! WorkBenchViewControllerV2).vm.middleVMDate.trupleVM.dayArr[selectedIndex].fireDayInfo.count
        //if count == 0 { return 0 }
        if count == 0 {
            return 2
        }
        return  count + 1
    }
    
    /// tb-[select one calerdar item - use indexpath-row return dingtalkEvent]
    func getCellModel(with indexRow:Int)->(eventModel: DingTalkCEvent?,dateInfo: String?) {
        let selectedIndex = self.logicMiddleVw.beselectedItemIndex
        if indexRow == 0 {
            let dateInfo = (self.viewController() as! WorkBenchViewControllerV2).vm.middleVMDate.trupleVM.dayArr[selectedIndex].dateInfo.dateToString(formatStr)
            return (nil,dateInfo)
        }
        if (self.viewController() as! WorkBenchViewControllerV2).vm.middleVMDate.trupleVM.dayArr[selectedIndex].fireDayInfo.count >= indexRow {
            let eventmodel =  (self.viewController() as! WorkBenchViewControllerV2).vm.middleVMDate.trupleVM.dayArr[selectedIndex].fireDayInfo[indexRow - 1]
            return (eventmodel,nil)
        }
        
        return (nil,nil)
    }
}
