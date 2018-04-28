//
//  DingTalkSingleLineChildVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/17.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class BigDingTalkSingleLineChildVw: UIView {
    
    var childsVwArr: [DingTalkCalenderRectLabelView] = []
    
    let normalDayLineHeight: CGFloat = 45 * APPDelStatic.sizeScale
    
    let eachItemWidth: CGFloat =  (UIScreen.main.bounds.width) / 7.0
    
    let selfWidth: CGFloat = (UIScreen.main.bounds.width)
    
    var beselectedItemIndex = 0
    
    var firstDayItemIndex = 0
    
    var vms: [DingTalkCalanderVModel]!
    
    var rectVwPadding:CGFloat = 10
    
    var rectVwSPadding:CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
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
            make.width.equalTo(selfWidth)
            make.bottom.equalTo(0)
        }
        for line in 0 ... 5 {
            for column in 0 ... 6 {
                let smallView = DingTalkCalenderRectLabelView(fatherView: self)
                smallView.snp.remakeConstraints { (make) in
                    make.left.equalTo(CGFloat(column) * eachItemWidth + rectVwPadding)
                    make.width.equalTo(eachItemWidth - rectVwPadding * 2)
                    make.height.equalTo(normalDayLineHeight - rectVwSPadding * 2)
                    make.top.equalTo(CGFloat(line) * normalDayLineHeight + rectVwSPadding)
                }
                self.childsVwArr.append(smallView)
                smallView.tapActionsGesture {
                    self.tapAction(index: column + (line) * 7)
                }
            }
        }
    }
    
    func setDates(with : [DingTalkCalanderVModel]) {
        self.vms = with
        let firstOf42DayMonth = with[0].dateInfo.month
        var changed:Bool = false
        for i in 0 ... self.childsVwArr.count - 1 {
            self.childsVwArr[i].setParameters(item: with[i], bigCalendarOrSamll: .all)
            if with[i].dateInfo.month != firstOf42DayMonth && !changed {
                self.beselectedItemIndex = i
                self.firstDayItemIndex = i
                changed = true
            }
        }
    }
}

// MARK: - tap action
extension BigDingTalkSingleLineChildVw {
    func tapAction(index:Int) {
        self.childsVwArr[self.beselectedItemIndex].deSelectedItem()
        self.beselectedItemIndex = index
        self.childsVwArr[index].beSelectedItem()
        (self.viewController() as! WorkBenchViewControllerV2).botVw.tabVw.reloadData()
    }
}
