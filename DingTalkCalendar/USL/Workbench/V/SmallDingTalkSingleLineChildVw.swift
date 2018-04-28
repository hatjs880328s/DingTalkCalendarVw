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
    
    let normalDayLineHeight: CGFloat = 45 * APPDelStatic.sizeScale
    
    let eachItemWidth: CGFloat =  (UIScreen.main.bounds.width) / 7.0
    
    var childsVwArr:[DingTalkCalenderRectLabelView] = []
    
    var position:ModelPosition!
    
    var animationActionEnd: (()->Void)!
    
    var selectedItemIndex: Int = 0
    
    var vms:[DingTalkCalanderVModel]!
    
    var rectVwPadding:CGFloat = 10
    
    var rectVwSPadding:CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
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
                make.left.equalTo((CGFloat(column) * eachItemWidth) + rectVwPadding)
                make.width.equalTo(eachItemWidth - rectVwPadding * 2)
                make.height.equalTo(normalDayLineHeight - rectVwSPadding * 2)
                make.top.equalTo(rectVwSPadding)
            }
            smallView.backgroundColor = UIColor.gray
            self.childsVwArr.append(smallView)
            smallView.tapActionsGesture {
                self.tapAction(index: column)
            }
        }
    }
    
    func setDate(models :[DingTalkCalanderVModel]) {
        self.vms = models
        for i in 0 ... self.childsVwArr.count - 1 {
            if i == 0 { models[i].smallCalendarSingleFirstItem = true }
            self.childsVwArr[i].setParameters(item: models[i], bigCalendarOrSamll: .single)
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

// MARK: - tap action
extension SmallDingTalkSingleLineChildVw {
    
    func tapAction(index:Int) {
        self.childsVwArr[self.selectedItemIndex].deSelectedItem()
        self.childsVwArr[index].beSelectedItem()
        self.selectedItemIndex = index
        (self.viewController() as! WorkBenchViewControllerV2).botVw.tabVw.reloadData()
    }
}
