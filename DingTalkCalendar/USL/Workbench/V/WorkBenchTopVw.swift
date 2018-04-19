//
//  WorkBenchTopVw.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/15.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class WorkBenchTopVw: UIView {
    
    var titleLb: UILabel = UILabel()
    
    var todayLb: UILabel = UILabel()
    
    var todayTxt: String = ""
    
    let todayStr = "今"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView(fatherView: UIView) {
        fatherView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(80)
        }
        //titlelab
        self.addSubview(titleLb)
        titleLb.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-5)
            make.height.equalTo(25)
            make.width.equalTo(120)
        }
        titleLb.textAlignment = .left
        titleLb.font = UIFont.systemFont(ofSize: 20)
        var dateTxt = ""
        dateTxt = (self.viewController() as! WorkBenchViewControllerV2).vm.getSerilizationDate(withDate: Date())
        self.todayTxt = dateTxt
        self.titleLb.text = dateTxt
        //today
        self.addSubview(todayLb)
        todayLb.snp.makeConstraints { (make) in
            make.left.equalTo(titleLb.snp.right).offset(5)
            make.width.equalTo(18)
            make.centerY.equalTo(titleLb.snp.centerY)
            make.height.equalTo(18)
        }
        todayLb.layer.cornerRadius = 9
        todayLb.layer.masksToBounds = true
        todayLb.text = todayStr
        todayLb.textAlignment = .center
        todayLb.textColor = UIColor.white
        todayLb.backgroundColor = APPDelStatic.dingtalkBlue
        todayLb.font = UIFont.systemFont(ofSize: 10)
        todayLb.alpha = 0
    }
    
    func setData(ifCalendar: Bool, titleTxt: String) {
        if ifCalendar && titleTxt == self.todayTxt {
            self.todayLb.alpha = 0
        }else{
            self.todayLb.alpha = 1
        }
        self.titleLb.text = titleTxt
    }
}
