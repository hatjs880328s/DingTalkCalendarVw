//
//  DingTalkCalenderRectLabelView.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/12.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class DingTalkCalenderRectLabelView: UIView {
    
    var uistate: UIState!
    
    var gregorionDayLb:UILabel = UILabel()
    
    var lunarDayLb: UILabel = UILabel()
    
    var circlePointVw: UIView = UIView()
    
    var restLb: UILabel = UILabel()
    
    var dateInfo: DingTalkCalanderVModel!
    
    var tapAction: ((_ tag: Int,_ initFirst:Bool,_ superView:UIView)->Void)!
    
    init(fatherView: UIView) {
        super.init(frame: CGRect.zero)
        fatherView.addSubview(self)
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// init the view
    func createView() {
        self.addSubview(gregorionDayLb)
        gregorionDayLb.snp.makeConstraints { (make) in
            make.top.equalTo(2 * APPDelStatic.sizeScale)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(15 * APPDelStatic.sizeScale)
        }
        gregorionDayLb.textAlignment = .center
        gregorionDayLb.font = APPDelStatic.uiFont(with: 15)
        self.addSubview(lunarDayLb)
        lunarDayLb.snp.makeConstraints { (make) in
            make.top.equalTo(gregorionDayLb.snp.bottom).offset(2 * APPDelStatic.sizeScale)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(10 * APPDelStatic.sizeScale)
        }
        lunarDayLb.textAlignment = .center
        lunarDayLb.font = APPDelStatic.uiFont(with: 9)
        self.addSubview(circlePointVw)
        circlePointVw.alpha = 0
        circlePointVw.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(lunarDayLb.snp.bottom).offset(2 * APPDelStatic.sizeScale)
            make.width.equalTo(5 * APPDelStatic.sizeScale)
            make.height.equalTo(5 * APPDelStatic.sizeScale)
        }
        circlePointVw.layer.cornerRadius = 2.5 * APPDelStatic.sizeScale
        circlePointVw.backgroundColor = APPDelStatic.dingtalkBlue
        self.addSubview(restLb)
        restLb.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.width.equalTo(12 * APPDelStatic.sizeScale)
            make.height.equalTo(12 * APPDelStatic.sizeScale)
            make.top.equalTo(2 * APPDelStatic.sizeScale)
        }
        restLb.font = APPDelStatic.uiFont(with: 9)
        restLb.textAlignment = .right
        restLb.textColor = UIColor.orange
    }
    
    /// setValue
    public func setParameters(item: DingTalkCalanderVModel,bigCalendarOrSamll: UIState) {
        self.uistate = bigCalendarOrSamll
        self.circlePointVw.alpha = 0
        self.dateInfo = item
        self.backgroundColor = UIColor.white
        self.gregorionDayLb.text = item.gregorionDay
        self.lunarDayLb.text = item.lunarDay
        self.restLb.text = item.isRestDay
        self.gregorionDayLb.textColor = UIColor.gray
        self.lunarDayLb.textColor = UIColor.gray
        // current month day
        if item.isCurrentMonthDay{
            self.gregorionDayLb.textColor = UIColor.black
            self.lunarDayLb.textColor = UIColor.gray
        }
        // today
        if item.isCurrentDay {
            self.gregorionDayLb.textColor = APPDelStatic.dingtalkBlue
            self.lunarDayLb.textColor = APPDelStatic.dingtalkBlue
            self.circlePointVw.backgroundColor = APPDelStatic.dingtalkBlue
        }
        // single state
        if bigCalendarOrSamll == .single {
            // small calendar first day
            if item.smallCalendarSingleFirstItem {
                beSelectedItem()
            }
        }else{
            // current month first day
            if item.isFirstDayCurrentMonth {
                beSelectedItem()
            }
        }
    }
    
    func beSelectedItem() {
        self.backgroundColor = APPDelStatic.dingtalkBlue
        self.gregorionDayLb.textColor = UIColor.white
        self.lunarDayLb.textColor = UIColor.white
        self.circlePointVw.backgroundColor = UIColor.white
        self.layer.cornerRadius = 2
    }
    
    func deSelectedItem() {
        self.backgroundColor = UIColor.white
        self.gregorionDayLb.text = self.dateInfo.gregorionDay
        self.lunarDayLb.text = self.dateInfo.lunarDay
        self.restLb.text = self.dateInfo.isRestDay
        self.gregorionDayLb.textColor = UIColor.gray
        self.lunarDayLb.textColor = UIColor.gray
        self.circlePointVw.backgroundColor = APPDelStatic.dingtalkBlue
        // current month day
        if self.dateInfo.isCurrentMonthDay{
            self.gregorionDayLb.textColor = UIColor.black
            self.lunarDayLb.textColor = UIColor.gray
        }
        // today
        if self.dateInfo.isCurrentDay {
            self.gregorionDayLb.textColor = APPDelStatic.dingtalkBlue
            self.lunarDayLb.textColor = APPDelStatic.dingtalkBlue
            self.circlePointVw.backgroundColor = APPDelStatic.dingtalkBlue
        }
    }
    
    /// if the day have story [kcevent] set alpha = 1
    func setEventDay() {
        //the day have a story
        self.circlePointVw.alpha = 1
    }
    
}
