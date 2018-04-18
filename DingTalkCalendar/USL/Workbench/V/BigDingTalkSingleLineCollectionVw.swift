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
    
    let normalDayLineHeight: CGFloat = 46
    
    var middleChildVw =  BigDingTalkSingleLineChildVw(frame: CGRect.zero)
    
    var leftChildVw: BigDingTalkSingleLineChildVw!
    
    var rightChildVw: BigDingTalkSingleLineChildVw!
    
    var logicMiddleVw: BigDingTalkSingleLineChildVw!
    
    var logicLeftVw: BigDingTalkSingleLineChildVw!
    
    var logicRightVw: BigDingTalkSingleLineChildVw!
     
    var topVw: UIView!
    
    var fatherVw: UIView!
    
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
        DispatchQueue.once {
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
            }
        }
    }
    
    @objc func swipeTopAction() {
        (self.viewController() as! WorkBenchViewControllerV2).hiddenMiddleCalendarVw()
    }
}
