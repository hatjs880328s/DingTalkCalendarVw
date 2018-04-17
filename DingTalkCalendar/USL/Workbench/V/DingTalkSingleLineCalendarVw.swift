//
//  DingTalkSingleLineCalendarVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/16.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import UIKit

class DingTalkSingleLineCalendarVw: UIView {
    
    let normalDayLineHeight: CGFloat = 46
    
    var middleChildVw =  DingTalkSingleLineChildVw(frame: CGRect.zero)
    
    var leftChildVw: DingTalkSingleLineChildVw!
    
    var rightChildVw: DingTalkSingleLineChildVw!
    
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
        fatherView.insertSubview(self, belowSubview: topView)
        self.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(normalDayLineHeight * 6)
        }
        initMiddleVw()
    }
    
    /// 2 other big child view
    private func createOther2ChildVw() {
        self.leftChildVw.createView(fatherView: self, position: .left)
        self.rightChildVw.createView(fatherView: self,position: .right)
    }
    
    /// middle child vw init
    fileprivate func initMiddleVw() {
        self.middleChildVw.createView(fatherView: self)
    }
    
    /// hidden self use lineNumber
    func hideTopAndBotVw(with lineNumber: Int) {
        let topDistance = CGFloat(lineNumber - 1) * normalDayLineHeight
        let _ = CGFloat(6 - lineNumber) * normalDayLineHeight
        self.snp.remakeConstraints { (make) in
            make.top.equalTo(self.topVw.snp.bottom).offset(-topDistance)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(6 * normalDayLineHeight)
        }
        // bot show
        (self.viewController() as! WorkBenchViewControllerV2).botVw.changeHeightWhenSwipeUp(with: lineNumber)
        
    }
    
    /// show self all
    func showTopAndeBotVw() {
        self.snp.makeConstraints { (make) in
            make.top.equalTo(self.topVw.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(normalDayLineHeight * 6)
        }
        // bot hidden
        (self.viewController() as! WorkBenchViewControllerV2).botVw.swipeDown()
    }
    
    /// DingTalkCalanderModel
    func setDates(with dates: [DingTalkCalanderVModel],which vw: DingTalkSingleLineChildVw) {
        //use vmodels set value to self.
        vw.setDates(with: dates)
    }
}
