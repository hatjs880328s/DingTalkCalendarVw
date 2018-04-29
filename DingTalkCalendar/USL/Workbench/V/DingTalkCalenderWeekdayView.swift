//
//  DingTalkCalenderWeekdayView.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/12.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import UIKit


class DingTalkCalenderWeekdayView: UIView {
    
    var weekArr = ["日","一","二","三","四","五","六"]
    
    let eachItemWidth: CGFloat =  (UIScreen.main.bounds.width) / 7.0
    
    let heightNormal: CGFloat = 30 * APPDelStatic.sizeScale
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    func createView(added fatherView: UIView,topView: UIView) {
        fatherView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(-0)
            make.height.equalTo(heightNormal)
            make.top.equalTo(topView.snp.bottom)
        }
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {
        let font = UIFont.systemFont(ofSize: 10 * APPDelStatic.sizeScale)
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
                make.top.equalTo(5 * APPDelStatic.sizeScale)
                make.height.equalTo(15 * APPDelStatic.sizeScale)
                make.width.equalTo(eachItemWidth)
            }
        }
    }
    
}
