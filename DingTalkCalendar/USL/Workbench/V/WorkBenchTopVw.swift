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
    
    var todayLbBackgroundColor: UIColor = UIColor.gray
    
    var todayTxt: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView(fatherView: UIView) {
        fatherView.insertSubview(self, at: 100)
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
            make.width.equalTo(100)
        }
        titleLb.textAlignment = .left
        titleLb.font = UIFont.systemFont(ofSize: 20)
        var dateTxt = ""
        GCDUtils.asyncProgress(dispatchLevel: 1, asyncDispathchFunc: {
            let dateInfo = Date().dateFormate("yyyy-MM-dd")
            dateTxt = "\(dateInfo.year)年\(dateInfo.month)月"
            self.todayTxt = dateTxt
        }) {
            self.titleLb.text = dateTxt
        }
        //today
        self.addSubview(todayLb)
        todayLb.snp.makeConstraints { (make) in
            make.left.equalTo(titleLb.snp.right).offset(5)
            make.width.equalTo(15)
            make.centerY.equalTo(titleLb.snp.centerY)
            make.height.equalTo(15)
        }
        todayLb.layer.cornerRadius = 7.5
        todayLb.layer.masksToBounds = true
        todayLb.text = "今"
        todayLb.textAlignment = .center
        todayLb.textColor = UIColor.white
        todayLb.backgroundColor = UIColor.blue
        todayLb.font = UIFont.systemFont(ofSize: 10)
    }
    
    func setData(ifCalendar: Bool, titleTxt: String) {
        if ifCalendar && titleTxt == self.todayTxt {
            self.todayLb.alpha = 1
        }else{
            self.todayLb.alpha = 0
        }
        self.titleLb.text = titleTxt
    }
}
