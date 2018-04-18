//
//  DingTalkSingleLineChildVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/17.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class BigDingTalkSingleLineCollectionVw: UIView {
    
    var childsVwArr: [DingTalkCalenderRectLabelView] = []
    
    let normalDayLineHeight: CGFloat = 46
    
    let eachItemWidth: CGFloat =  (UIScreen.main.bounds.width) / 7.0
    
    let selfWidth: CGFloat = (UIScreen.main.bounds.width)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView(fatherView: UIView , position: ModelPosition = .middle) {
        fatherView.addSubview(self)
        var leftdistance:CGFloat = 0
        switch position {
        case .middle:
            leftdistance = 0
        case .left:
            leftdistance = -selfWidth
        case .right:
            leftdistance = selfWidth
        }
        self.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(leftdistance)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        for line in 0 ... 5 {
            for column in 0 ... 6 {
                let smallView = DingTalkCalenderRectLabelView(fatherView: self)
                smallView.snp.remakeConstraints { (make) in
                    make.left.equalTo((CGFloat(column) * eachItemWidth))
                    make.width.equalTo(eachItemWidth)
                    make.height.equalTo(normalDayLineHeight)
                    make.top.equalTo(CGFloat(line) * normalDayLineHeight)
                }
                self.childsVwArr.append(smallView)
            }
        }
    }
    
    func setDates(with : [DingTalkCalanderVModel]) {
        for i in 0 ... self.childsVwArr.count - 1 {
            self.childsVwArr[i].setParameters(item: with[i])
        }
    }
}
