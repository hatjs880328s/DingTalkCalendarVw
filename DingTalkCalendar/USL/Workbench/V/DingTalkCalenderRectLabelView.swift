//
//  DingTalkCalenderRectLabelView.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/12.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class DingTalkCalenderRectLabelView: UIView {
    
    var gregorionDayLb:UILabel = UILabel()
    
    var lunarDayLb: UILabel = UILabel()
    
    var circlePointVw: UIView = UIView()
    
    var restLb: UILabel = UILabel()
    
    var dateInfo: DingTalkCalanderVModel!
    
    var tapAction: ((_ tag: Int,_ initFirst:Bool,_ superView:UIView)->Void)!
    
    init(fatherView: UIView) {
        super.init(frame: CGRect.zero)
        fatherView.addSubview(self)
        self.backgroundColor = UIColor.yellow
        createView()
        self.tapActionsGesture {[weak self]() in
            self?.selectOneItem()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// init the view
    func createView() {
        self.addSubview(gregorionDayLb)
        gregorionDayLb.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(15)
        }
        gregorionDayLb.textAlignment = .center
        gregorionDayLb.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(lunarDayLb)
        lunarDayLb.snp.makeConstraints { (make) in
            make.top.equalTo(gregorionDayLb.snp.bottom).offset(2)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(15)
        }
        lunarDayLb.textAlignment = .center
        lunarDayLb.font = UIFont.systemFont(ofSize: 11)
        self.addSubview(circlePointVw)
        circlePointVw.alpha = 0
        circlePointVw.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(lunarDayLb.snp.bottom).offset(2)
            make.width.equalTo(5)
            make.height.equalTo(5)
        }
        circlePointVw.layer.cornerRadius = 2.5
        circlePointVw.backgroundColor = UIColor.gray
        self.addSubview(restLb)
        restLb.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.width.equalTo(12)
            make.height.equalTo(12)
            make.top.equalTo(2)
        }
        restLb.font = UIFont.systemFont(ofSize: 9)
        restLb.textAlignment = .right
        restLb.textColor = UIColor.orange
    }
    
    /// setValue
    public func setParameters(item: DingTalkCalanderVModel) {
        self.circlePointVw.alpha = 0
        self.dateInfo = item
        self.backgroundColor = UIColor.white
        self.gregorionDayLb.text = item.gregorionDay
        self.lunarDayLb.text = item.lunarDay
        self.restLb.text = item.isRestDay
        self.gregorionDayLb.textColor = UIColor.gray
        self.lunarDayLb.textColor = UIColor.gray
        //current month day
        if item.isCurrentMonthDay{
            self.gregorionDayLb.textColor = UIColor.black
            self.lunarDayLb.textColor = UIColor.gray
        }
        //current day
//        if item.isCurrentDay {
//            self.gregorionDayLb.textColor = UIColor.blue
//            self.lunarDayLb.textColor = UIColor.blue
//        }
        //first day this month
        if item.isCurrentMonthDay {
            let dateInfo = Date().dateFormate("yyyy-MM-dd")
            if item.dateInfo.year == dateInfo.year && item.dateInfo.month == dateInfo.month {
                if item.dateInfo.days == dateInfo.days {
                    beSelectedItem()
                    changeToFirstDay(true)
                }else{
                    // donothing
                }
            }else{
                beSelectedItem()
                changeToFirstDay(true)
            }
        }
    }
    
    /// this month first day ui progress  || beselected day
    func beSelectedItem() {
        self.backgroundColor = UIColor.gray
        self.gregorionDayLb.textColor = UIColor.white
        self.lunarDayLb.textColor = UIColor.white
        self.circlePointVw.backgroundColor = UIColor.white
        self.layer.cornerRadius = 2
    }
    
    /// if the day have story [kcevent] set alpha = 1
    func setEventDay() {
        //the day have a story
        self.circlePointVw.alpha = 1
    }
    
}

// MARK: - TAP ACTION
extension DingTalkCalenderRectLabelView {
    
    /// init the parameter is true else is false
    func changeToFirstDay(_ initFirst: Bool) {
        if self.tapAction == nil || self.superview == nil { return }
        tapAction(self.tag,initFirst,self.superview!)
    }
    
    /// other rect vw beselected ; old rect vw should be changed to normal
    func changeToNormal() {
        self.circlePointVw.backgroundColor = UIColor.gray
        self.backgroundColor = UIColor.white
        self.gregorionDayLb.text = dateInfo.gregorionDay
        self.lunarDayLb.text = dateInfo.lunarDay
        self.restLb.text = dateInfo.isRestDay
        self.gregorionDayLb.textColor = UIColor.gray
        self.lunarDayLb.textColor = UIColor.gray
        //current month day
        if dateInfo.isCurrentMonthDay{
            self.gregorionDayLb.textColor = UIColor.black
            self.lunarDayLb.textColor = UIColor.gray
        }
        //current day
        if dateInfo.isCurrentDay {
            self.gregorionDayLb.textColor = UIColor.blue
            self.lunarDayLb.textColor = UIColor.blue
        }
    }
    
    /// selectAction
    func selectOneItem() {
        changeToFirstDay(false)
        beSelectedItem()
    }
}
