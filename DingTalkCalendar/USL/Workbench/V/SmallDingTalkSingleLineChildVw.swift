//
//  SmallDingTalkSingleLineChildVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/17.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class SmallDingTalkSingleLineChildVw: UIView {
    
    let width = UIScreen.main.bounds.width
    
    let normalDayLineHeight: CGFloat = 46
    
    let eachItemWidth: CGFloat =  (UIScreen.main.bounds.width) / 7.0
    
    var childsVwArr:[DingTalkCalenderRectLabelView] = []
    
    var position:ModelPosition!
    
    var animationActionEnd: (()->Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.borderColor = UIColor.red
        self.borderWidth = 0.6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// add to vc's view
    func createView(fatherView: UIView,position: ModelPosition) {
        self.position = position
        fatherView.addSubview(self)
        var leftDis:CGFloat = 0
        if position != .middle {
            leftDis = position == .left ? -width : width
        }
        self.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(leftDis)
            make.width.equalTo(width)
            make.height.equalTo(normalDayLineHeight)
        }
        for column in 0 ... 6 {
            let smallView = DingTalkCalenderRectLabelView(fatherView: self)
            smallView.snp.remakeConstraints { (make) in
                make.left.equalTo((CGFloat(column) * eachItemWidth))
                make.width.equalTo(eachItemWidth)
                make.height.equalTo(normalDayLineHeight)
                make.top.equalTo(0)
            }
            smallView.backgroundColor = UIColor.gray
            self.childsVwArr.append(smallView)
        }
    }
    
    
    
    func setDate(models :[DingTalkCalanderVModel]) {
        for i in 0 ... self.childsVwArr.count - 1 {
            self.childsVwArr[i].setParameters(item: models[i])
        }
    }
    
    func swipeLeftAndRight() {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame.origin.x = 0
        }) { (completed) in
            if self.animationActionEnd == nil { return }
            self.animationActionEnd!()
        }
    }
    
    func swipeEndChangedNormal() {
        let left = position == .left ? -width : width
        self.frame.origin.x = left
    }
    
}

extension SmallDingTalkSingleLineChildVw {
    
    @objc func swipeLeftAction() {
        
    }
    
    @objc func swipeRightAction() {
        
    }
    
    @objc func swipeTopAction() {
        
    }
    
    @objc func swipeDownAction() {
        
    }
}
