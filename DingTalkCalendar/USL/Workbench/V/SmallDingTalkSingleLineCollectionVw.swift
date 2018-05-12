//
//  SmallDingTalkSingleLineCollectionVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/17.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class SmallDingTalkSingleLineCollectionVw: UIView {
    
    let width = UIScreen.main.bounds.width
    
    let normalDayLineHeight: CGFloat = 45 * APPDelStatic.sizeScale
    
    let eachItemWidth: CGFloat =  (UIScreen.main.bounds.width) / 7.0
    
    var topView: UIView!
    
    var fatherVw: UIView!
    
    let smallLeftCalendarVw: SmallDingTalkSingleLineChildVw = SmallDingTalkSingleLineChildVw(frame: CGRect.zero)
    
    let smallRightCalendarVw: SmallDingTalkSingleLineChildVw = SmallDingTalkSingleLineChildVw(frame: CGRect.zero)
    
    let smallMiddleCalendarVw: SmallDingTalkSingleLineChildVw = SmallDingTalkSingleLineChildVw(frame: CGRect.zero)
    
    var smallMiddleLogicVw: SmallDingTalkSingleLineChildVw!
    
    var smallLeftLogicVw: SmallDingTalkSingleLineChildVw!
    
    var smallRightLogicVw: SmallDingTalkSingleLineChildVw!
    
    var smallCalendarCollectionSwipeHorEndAction: ((_ singleLineFirstDay: Date)->Void)!
    
    let formatStr = "MM月dd日"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView(fatherView: UIView,topView: UIView) {
        self.topView = topView
        self.fatherVw = fatherView
        fatherView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(normalDayLineHeight)
        }
        createSmallCalendarVw()
        self.addGesture(to: self)
    }
    
    /// small calendar vw
    func createSmallCalendarVw() {
        smallLeftCalendarVw.createView(fatherView: self, position: .left)
        smallRightCalendarVw.createView(fatherView: self, position: .right)
        smallMiddleCalendarVw.createView(fatherView: self, position: .middle)
        
        self.smallMiddleLogicVw = self.smallMiddleCalendarVw
        self.smallLeftLogicVw = self.smallLeftCalendarVw
        self.smallRightLogicVw = self.smallRightCalendarVw
    }
    
    func addGesture(to dateVw: UIView) {
        let leftGsture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        leftGsture.direction = .left
        dateVw.addGestureRecognizer(leftGsture)
        let rightGsture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        rightGsture.direction = .right
        dateVw.addGestureRecognizer(rightGsture)
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
        downGesture.direction = .down
        dateVw.addGestureRecognizer(downGesture)
    }
    
    func setDates(date: [DingTalkCalanderVModel],position: ModelPosition) {
        switch position {
        case .middle:
            self.smallMiddleLogicVw.setDate(models: date)
        case .left:
            self.smallLeftLogicVw.setDate(models: date)
        case .right:
            self.smallRightLogicVw.setDate(models: date)
        }
    }
    
    
}

// MARK: - swipe actions
extension SmallDingTalkSingleLineCollectionVw {
    
    func whenSwipeTapFistItem() {
        self.smallMiddleLogicVw.tapAction(index: 0)
        self.smallRightLogicVw.tapAction(index: 0)
        self.smallLeftLogicVw.tapAction(index: 0)
    }
    
    /// swipe left - get new right dates
    @objc func swipeLeftAction() {
        // no animate
        self.smallLeftLogicVw.frame.origin.x = self.width
        // have animate
        UIView.animate(withDuration: 0.5, animations: {
            self.smallMiddleLogicVw.frame.origin.x = -self.width
            self.smallRightLogicVw.frame.origin.x = 0
        }) { (completed) in
            if completed {
                // logic change
                let changeMiddleParameter = self.smallMiddleLogicVw
                self.smallMiddleLogicVw = self.smallRightLogicVw
                self.smallRightLogicVw = self.smallLeftLogicVw
                self.smallLeftLogicVw = changeMiddleParameter
                self.smallRightLogicVw.setDate(models: (self.viewController() as! WorkBenchViewControllerV2).vm.smallSwipeleft())
                (self.viewController() as! WorkBenchViewControllerV2).smallCalendarSwipeHor()
                self.whenSwipeTapFistItem()
                (self.viewController() as! WorkBenchViewControllerV2).getTodayEvents()
            }
        }
    }
    
    /// swipe right - get new left dates
    @objc func swipeRightAction() {
        // no animate
        self.smallRightLogicVw.frame.origin.x = -self.width
        // have animate
        UIView.animate(withDuration: 0.5, animations: {
            self.smallLeftLogicVw.frame.origin.x = 0
            self.smallMiddleLogicVw.frame.origin.x = self.width
        }) { (completed) in
            if completed {
                // logic change
                let changeMiddleParameter = self.smallMiddleLogicVw
                self.smallMiddleLogicVw = self.smallLeftLogicVw
                self.smallLeftLogicVw = self.smallRightLogicVw
                self.smallRightLogicVw = changeMiddleParameter
                self.smallLeftLogicVw.setDate(models: (self.viewController() as! WorkBenchViewControllerV2).vm.smallSwipeRight())
                (self.viewController() as! WorkBenchViewControllerV2).smallCalendarSwipeHor()
                self.whenSwipeTapFistItem()
                (self.viewController() as! WorkBenchViewControllerV2).getTodayEvents()
            }
        }
    }
    
    @objc func swipeDownAction() {
        self.alpha = 0
        (self.viewController() as! WorkBenchViewControllerV2).showMiddleCalcendarVw(animated: true)
        (self.viewController() as! WorkBenchViewControllerV2).swipeDownSelectedBigCalendarItem(with: self.smallMiddleLogicVw.vms![self.smallMiddleLogicVw.selectedItemIndex].dateInfo)
    }
}

extension SmallDingTalkSingleLineCollectionVw {
    
    //set events info with kcevent just in logicMiddlePic
    func setEvents(with: [DingTalkCalanderVModel]) {
        var resultArr = [Int: Bool]()
        let middleLogic = self.smallMiddleLogicVw
        GCDUtils.asyncProgress(dispatchLevel: 1, asyncDispathchFunc: {
            for eachItem in 0 ... with.count - 1 {
                if with[eachItem].isFireDay {
                    resultArr[eachItem] = true
                }
            }
        }) {
            for eachItem in resultArr {
                middleLogic?.childsVwArr[eachItem.key].setEventDay()
            }
        }
    }
}

// MARK: - tb actions
extension SmallDingTalkSingleLineCollectionVw {
    /// tb-[cell number]
    func getCellModelsCount()->Int {
        let selectedIndex = self.smallMiddleLogicVw.selectedItemIndex
        let count = (self.viewController() as! WorkBenchViewControllerV2).vm.smallMiddleDate[selectedIndex].fireDayInfo.count
        if count == 0 {
            return 3
        }
        return  count + 2
    }
    
    /// tb-[select one calerdar item - use indexpath-row return dingtalkEvent]
    func getCellModel(with indexRow:Int)->(eventModel: DingTalkCEvent?,dateInfo: String?) {
        let selectedIndex = self.smallMiddleLogicVw.selectedItemIndex
        if indexRow == 0 {
            let realDateInfo = (self.viewController() as! WorkBenchViewControllerV2).vm.smallMiddleDate[selectedIndex].dateInfo
            var dateInfo = ""
            if APPDelStatic.internationalProgress {
                dateInfo = "\(realDateInfo!.getEuMonth(month: realDateInfo!.month)) \(realDateInfo!.days)"
            }else{
                dateInfo = realDateInfo!.dateToString(formatStr)
            }
            
            return (nil,dateInfo)
        }
        if (self.viewController() as! WorkBenchViewControllerV2).vm.smallMiddleDate[selectedIndex].fireDayInfo.count >= indexRow {
            let eventmodel =  (self.viewController() as! WorkBenchViewControllerV2).vm.smallMiddleDate[selectedIndex].fireDayInfo[indexRow - 1]
            return (eventmodel,nil)
        }
        
        return (nil,nil)
    }
}
