//
//  DingTalkCalenderWeekdayView.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/12.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class DingTalkCalenderWeekdayView: UIView {
    
    var weekArr = ["日","一","二","三","四","五","六"]
    
    let eachItemWidth: CGFloat =  (UIScreen.main.bounds.width - 10) / 7.0
    
    init(added fatherView: UIView) {
        super.init(frame: CGRect.zero)
        fatherView.addSubview(self)
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {
        let font = UIFont.systemFont(ofSize: 10)
        let color = UIColor.gray
        let center = NSTextAlignment.center
        for eachItem in 0 ... 6 {
            let weekVw = UILabel()
            self.addSubview(weekVw)
            weekVw.text = weekArr[eachItem]
            weekVw.font = font
            weekVw.textAlignment = center
            weekVw.textColor = color
            weekVw.snp.makeConstraints { (make) in
                make.left.equalTo(CGFloat(eachItem) * eachItemWidth)
                make.top.equalTo(5)
                make.height.equalTo(15)
                make.width.equalTo(eachItemWidth)
            }
        }
    }
    
}
