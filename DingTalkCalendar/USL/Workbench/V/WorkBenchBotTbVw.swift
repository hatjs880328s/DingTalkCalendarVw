//
//  WorkBenchBotTbVw.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/15.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import UIKit


class WorkBenchBotTbVw: UIView,UITableViewDelegate,UITableViewDataSource {
    
    let tabVw: UITableView = UITableView(frame: CGRect.zero)
    
    var topView: UIView!
    
    var topLength: CGFloat = 10
    
    let normalDayLineHeight: CGFloat = 49
    
    let tbReuseID:String = "workBenchReuseID"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    func createVw(topView:UIView,fatherView:UIView) {
        self.topView = topView
        fatherView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-0)
        }
        let lightView: UIView = UIView(frame: CGRect.zero)
        self.addSubview(lightView)
        lightView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(topLength)
        }
        lightView.backgroundColor = APPDelStatic.lightGray
        self.addSubview(tabVw)
        tabVw.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0).offset(topLength)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
        }
        tabVw.delegate = self
        tabVw.dataSource = self
        tabVw.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: tbReuseID)
            
            let con = (self.viewController() as! WorkBenchViewControllerV2)
            var resultDate: (eventModel: DingTalkCEvent?,dateInfo: String?)!
            if con.vm.uistate == .all {
                resultDate = (self.viewController() as! WorkBenchViewControllerV2).calendarVw.getCellModel(with: indexPath.row)
            }else{
                resultDate = (self.viewController() as! WorkBenchViewControllerV2).smallCalendarVw.getCellModel(with: indexPath.row)
            }
            cell.textLabel?.text = resultDate.dateInfo!
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            let botLine = UIView()
            cell.addSubview(botLine)
            botLine.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(0)
                make.height.equalTo(0.5)
                make.bottom.equalTo(0.5)
            }
            cell.selectionStyle = .none
            botLine.backgroundColor = APPDelStatic.lightGray
            return cell
        }else{
            let cell = WorkBenchTBCell(style: UITableViewCellStyle.default, reuseIdentifier: tbReuseID)
            let con = (self.viewController() as! WorkBenchViewControllerV2)
            var resultDate: (eventModel: DingTalkCEvent?,dateInfo: String?)!
            if con.vm.uistate == .all {
                resultDate = (self.viewController() as! WorkBenchViewControllerV2).calendarVw.getCellModel(with: indexPath.row)
            }else{
                resultDate = (self.viewController() as! WorkBenchViewControllerV2).smallCalendarVw.getCellModel(with: indexPath.row)
            }
            if resultDate.eventModel != nil {
                cell.setDate(with: resultDate.eventModel!)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 30
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let con = (self.viewController() as! WorkBenchViewControllerV2)
        var count = 0
        if con.vm.uistate == .all {
            count = con.calendarVw.getCellModelsCount()
        }else{
            count = con.smallCalendarVw.getCellModelsCount()
        }
        //changeHeight(cellCount: count)
        
        return count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// didSelected  One item chagne tb frame
    func changeHeight(cellCount: Int) {
        let maxHeight = UIScreen.main.bounds.size.height - self.topView.frame.origin.y - self.topView.frame.size.height - self.viewController()!.tabBarController!.tabBar.frame.height - topLength
        if cellCount == 0 {
            self.alpha = 0
            return
        }
        self.alpha = 1
        var height: CGFloat = (CGFloat(cellCount) * 60) - 30.0
        if height > maxHeight {
            height = maxHeight
        }
        self.snp.remakeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(height)
        }
    }
    
    /// swipe up
    func swipeUp(withAnimation: Bool = false) {
        self.snp.remakeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom).offset(normalDayLineHeight)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        if withAnimation {
            (self.viewController() as! WorkBenchViewControllerV2).smallCalendarVw.alpha = 1
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }else{
            (self.viewController() as! WorkBenchViewControllerV2).smallCalendarVw.alpha = 1
        }
    }
    
    /// swipe down
    func swipeDown(withAnimation: Bool = false) {
        self.snp.remakeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(normalDayLineHeight * 6)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-0)
        }
        if withAnimation {
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        }
    }
}

class WorkBenchTBCell: UITableViewCell {
    
    let dateStart = UILabel()
    
    let dateEnd = UILabel()
    
    let titleLb = UILabel()
    
    let imagePic = UIImageView()
    
    let subTitleLb = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        //ceateVW
        self.addSubview(dateStart)
        self.addSubview(dateEnd)
        self.addSubview(titleLb)
        self.addSubview(imagePic)
        self.addSubview(subTitleLb)
        //start date
        dateStart.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.width.equalTo(50)
            make.height.equalTo(14)
            make.top.equalTo(15)
        }
        dateStart.font = UIFont.systemFont(ofSize: 13)
        //end date
        dateEnd.snp.makeConstraints { (make) in
            make.left.equalTo(dateStart.snp.left)
            make.width.equalTo(70)
            make.height.equalTo(14)
            make.top.equalTo(dateStart.snp.bottom).offset(5)
        }
        dateEnd.font = UIFont.systemFont(ofSize: 11)
        dateEnd.textColor = UIColor.gray
        //image
        imagePic.snp.makeConstraints { (make) in
            make.left.equalTo(dateStart.snp.right).offset(4)
            make.width.equalTo(10)
            make.bottom.equalTo(dateStart.snp.bottom)
            make.height.equalTo(14)
        }
        imagePic.image = UIImage(named: "survey.png")
        //title
        titleLb.snp.makeConstraints { (make) in
            make.left.equalTo(imagePic.snp.right).offset(10)
            make.top.equalTo(dateStart.snp.top)
            make.height.equalTo(18)
            make.width.equalTo(200)
        }
        titleLb.font = UIFont.systemFont(ofSize: 16)
        //subtitle
        subTitleLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(-5)
            make.right.equalTo(-18)
            make.width.equalTo(200)
            make.height.equalTo(15)
        }
        subTitleLb.textAlignment = .right
        subTitleLb.font = UIFont.systemFont(ofSize: 11)
        subTitleLb.textColor = UIColor.gray
        //bot line
        let botLine = UIView()
        self.addSubview(botLine)
        botLine.snp.makeConstraints { (make) in
            make.left.equalTo(imagePic.snp.left)
            make.right.equalTo(0)
            make.bottom.equalTo(-0.5)
            make.height.equalTo(0.5)
        }
        botLine.backgroundColor = APPDelStatic.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDate(with model: DingTalkCEvent) {
        self.subTitleLb.text = model.subTitle
        self.titleLb.text = model.title
        self.dateStart.text = model.startTime
        self.dateEnd.text = model.endTime
        self.imagePic.image = UIImage(named: "survey.png")
    }
    
}


