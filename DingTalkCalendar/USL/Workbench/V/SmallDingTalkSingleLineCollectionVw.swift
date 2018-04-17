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
    
    let normalDayLineHeight: CGFloat = 46
    
    let eachItemWidth: CGFloat =  (UIScreen.main.bounds.width) / 7.0
    
    var topView: UIView!
    
    var fatherVw: UIView!
    
    let smallLeftCalendarVw: SmallDingTalkSingleLineChildVw = SmallDingTalkSingleLineChildVw(frame: CGRect.zero)
    
    let smallRightCalendarVw: SmallDingTalkSingleLineChildVw = SmallDingTalkSingleLineChildVw(frame: CGRect.zero)
    
    let smallMiddleCalendarVw: SmallDingTalkSingleLineChildVw = SmallDingTalkSingleLineChildVw(frame: CGRect.zero)
    
    var smallMiddleLogicVw: SmallDingTalkSingleLineChildVw!
    
    var smallLeftLogicVw: SmallDingTalkSingleLineChildVw!
    
    var smallRightLogicVw: SmallDingTalkSingleLineChildVw!
    
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
        let topGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeTopAction))
        topGesture.direction = .up
        dateVw.addGestureRecognizer(topGesture)
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
        downGesture.direction = .down
        dateVw.addGestureRecognizer(downGesture)
    }
    
    func setDates(date: [DingTalkCalanderVModel],position: ModelPosition) {
        switch position {
        case .middle:
            self.smallMiddleCalendarVw.setDate(models: date)
        case .left:
            self.smallLeftCalendarVw.setDate(models: date)
        case .right:
            self.smallRightCalendarVw.setDate(models: date)
        }
    }
    
    
}

extension SmallDingTalkSingleLineCollectionVw {
    
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
            }
        }
    }
    
    @objc func swipeTopAction() {
        
    }
    
    @objc func swipeDownAction() {
        
    }
}
