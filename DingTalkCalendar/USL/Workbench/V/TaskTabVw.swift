//
//  TaskTabVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import UIKit

class TaskTabVw: UIView,UITableViewDelegate,UITableViewDataSource {
    
    var tabVw: UITableView!
    
    var isMeetingTab:Bool = false
    
    init(frame: CGRect,fatherVw: UIView,topView: UIView,isMeetingTAB:Bool = false) {
        super.init(frame: frame)
        self.isMeetingTab = isMeetingTAB
        fatherVw.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(topView.snp.bottom)
        }
        initTheVw()
    }
    
    func initTheVw() {
        self.tabVw = UITableView()
        self.addSubview(tabVw)
        tabVw.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        }
        tabVw.delegate = self
        tabVw.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMeetingTab {
            return (self.superview as! MeetingContainerVw).vm.cellModels.count
        }
        return (self.viewController() as! WorkBenchViewControllerV2).taskVM.getVMCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isMeetingTab {
            let cell = MeetingTBCell(style: UITableViewCellStyle.default, reuseIdentifier: "meetingReuseID")
            let cellModel = (self.superview as! MeetingContainerVw).vm.getCellWithIndexpathrow(pathRow: indexPath.row)
            cell.setData(with: cellModel)
            return cell
        }
        let cell = TaskTBCell(style: UITableViewCellStyle.default, reuseIdentifier: "taskreuseID")
        let cellModel = (self.viewController() as! WorkBenchViewControllerV2).taskVM.getVModelWithIndex(indexPathRow: indexPath.row)
        cell.setData(with: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isMeetingTab {
            return (self.superview as! MeetingContainerVw).vm.getCellWithIndexpathrow(pathRow: indexPath.row).cellHeight
        }
        return (self.viewController() as! WorkBenchViewControllerV2).taskVM.getVModelWithIndex(indexPathRow: indexPath.row).cellHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TaskTBCell: UITableViewCell {
    
    let checkBox = UIImageView()
    
    let stateBtn = UILabel()
    
    let titleLab = UILabel()
    
    let endTime = UILabel()
    
    let pic = UIImageView()
    
    let toPerson = UILabel()
    
    let createTime = UILabel()
    
    let completedPersonCount = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        createVw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createVw() {
        // state btn
        self.addSubview(stateBtn)
        stateBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-18)
            make.top.equalTo(10)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        stateBtn.font = APPDelStatic.uiFont(with: 11)
        stateBtn.layer.cornerRadius = 2
        stateBtn.layer.borderColor = UIColor.gray.cgColor
        stateBtn.layer.borderWidth = 0.5
        stateBtn.textColor = UIColor.gray
        stateBtn.textAlignment = .center
        // selected box
        self.addSubview(checkBox)
        checkBox.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.width.equalTo(15)
            make.top.equalTo(15)
            make.height.equalTo(15)
        }
        checkBox.backgroundColor = APPDelStatic.lightGray
        // title
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(checkBox.snp.right).offset(10)
            make.right.equalTo(-18)
            make.centerY.equalTo(checkBox.snp.centerY)
            make.height.equalTo(25)
        }
        titleLab.numberOfLines = 0
        titleLab.font = APPDelStatic.uiFont(with: 14)
        // pic
        let picWidth = APPDelStatic.textLength(text: "MM月dd日 x HH:mm xx", font: APPDelStatic.uiFont(with: 11))
        self.addSubview(pic)
        pic.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left).offset(0)
            make.width.equalTo(picWidth)
            make.top.equalTo(titleLab.snp.bottom).offset(5)
            make.height.equalTo(picWidth * 1.3)
        }
        pic.layer.cornerRadius = 3
        pic.layer.borderColor = UIColor.gray.cgColor
        pic.layer.borderWidth = 0.5
        // end time
        self.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.right.equalTo(-18)
            make.top.equalTo(pic.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        endTime.font = APPDelStatic.uiFont(with: 11)
        endTime.textColor = UIColor.gray
        // toPerson
        let toPersonWidth = APPDelStatic.textLength(text: "给自己的", font: APPDelStatic.uiFont(with: 11))
        self.addSubview(toPerson)
        toPerson.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.width.equalTo(toPersonWidth)
            make.top.equalTo(endTime.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        toPerson.font = APPDelStatic.uiFont(with: 11)
        toPerson.textColor = APPDelStatic.dingtalkBlue
        // HOLine
        let hoLine = UIView()
        self.addSubview(hoLine)
        hoLine.snp.makeConstraints { (make) in
            make.left.equalTo(toPerson.snp.right).offset(2)
            make.width.equalTo(1)
            make.centerY.equalTo(toPerson.snp.centerY)
            make.height.equalTo(11)
        }
        hoLine.backgroundColor = APPDelStatic.lightGray
        // createTime
        self.addSubview(createTime)
        createTime.snp.makeConstraints { (make) in
            make.left.equalTo(toPerson.snp.right).offset(10)
            make.right.equalTo(-18)
            make.top.equalTo(toPerson.snp.top)
            make.height.equalTo(15)
        }
        createTime.font = APPDelStatic.uiFont(with: 11)
        createTime.textColor = UIColor.gray
        // completedPersonCount
        self.addSubview(completedPersonCount)
        completedPersonCount.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.right.equalTo(-18)
            make.top.equalTo(createTime.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        completedPersonCount.font = APPDelStatic.uiFont(with: 11)
        completedPersonCount.textColor = UIColor.gray
    }
    
    func setData(with: DingtaskVModel) {
        self.stateBtn.text = with.state
        self.titleLab.text = with.title
        self.endTime.text = with.endTime
        self.pic.sd_setImage(with: nil, placeholderImage: UIImage(named: "richengNew.png"), options: SDWebImageOptions.lowPriority, completed: nil)
        self.toPerson.text = with.toPerson
        self.createTime.text = with.createTime
        self.completedPersonCount.text = with.completedInfo
    }
}

class MeetingTBCell: UITableViewCell {
    
    let topImg = UIImageView()
    
    let stateBtn = UILabel()
    
    let titleLab = UILabel()
    
    let durationTime = UILabel()
    
    let addressLb = UILabel()
    
    let pic = UIImageView()
    
    let createPerson = UILabel()
    
    let createTime = UILabel()
    
    let completedPersonCount = UILabel()
    
    let taskLb = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        createVw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createVw() {
        // state btn
        self.addSubview(stateBtn)
        stateBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-18)
            make.top.equalTo(10)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        stateBtn.font = APPDelStatic.uiFont(with: 11)
        stateBtn.layer.cornerRadius = 2
        stateBtn.layer.borderColor = UIColor.gray.cgColor
        stateBtn.layer.borderWidth = 0.5
        stateBtn.textColor = UIColor.gray
        stateBtn.textAlignment = .center
        // selected box
        self.addSubview(topImg)
        topImg.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.width.equalTo(15)
            make.top.equalTo(15)
            make.height.equalTo(15)
        }
        topImg.image = UIImage(named: "survey.png")
        // title
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(topImg.snp.right).offset(10)
            make.right.equalTo(-18)
            make.centerY.equalTo(topImg.snp.centerY)
            make.height.equalTo(25)
        }
        titleLab.numberOfLines = 0
        titleLab.font = APPDelStatic.uiFont(with: 14)
        // duration time
        self.addSubview(durationTime)
        durationTime.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.right.equalTo(-18)
            make.top.equalTo(titleLab.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        durationTime.font = APPDelStatic.uiFont(with: 11)
        durationTime.textColor = UIColor.gray
        // address
        self.addSubview(addressLb)
        addressLb.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.right.equalTo(-18)
            make.top.equalTo(durationTime.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        addressLb.font = APPDelStatic.uiFont(with: 11)
        addressLb.textColor = UIColor.gray
        // pic
        let picWidth = APPDelStatic.textLength(text: "MM月dd日 x HH:mm xx", font: APPDelStatic.uiFont(with: 11))
        self.addSubview(pic)
        pic.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left).offset(0)
            make.width.equalTo(picWidth)
            make.top.equalTo(addressLb.snp.bottom).offset(5)
            make.height.equalTo(picWidth * 1.3)
        }
        pic.layer.cornerRadius = 3
        pic.layer.borderColor = UIColor.gray.cgColor
        pic.layer.borderWidth = 0.5
        
        // toPerson
        let toPersonWidth = APPDelStatic.textLength(text: "给自己的", font: APPDelStatic.uiFont(with: 11))
        self.addSubview(createPerson)
        createPerson.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.width.equalTo(toPersonWidth)
            make.top.equalTo(pic.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        createPerson.font = APPDelStatic.uiFont(with: 11)
        createPerson.textColor = APPDelStatic.dingtalkBlue
        // HOLine
        let hoLine = UIView()
        self.addSubview(hoLine)
        hoLine.snp.makeConstraints { (make) in
            make.left.equalTo(createPerson.snp.right).offset(2)
            make.width.equalTo(1)
            make.centerY.equalTo(createPerson.snp.centerY)
            make.height.equalTo(11)
        }
        hoLine.backgroundColor = APPDelStatic.lightGray
        // createTime
        self.addSubview(createTime)
        createTime.snp.makeConstraints { (make) in
            make.left.equalTo(createPerson.snp.right).offset(10)
            make.right.equalTo(-18)
            make.top.equalTo(createPerson.snp.top)
            make.height.equalTo(15)
        }
        createTime.font = APPDelStatic.uiFont(with: 11)
        createTime.textColor = UIColor.gray
        // completedPersonCount
        self.addSubview(completedPersonCount)
        completedPersonCount.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.right.equalTo(-18)
            make.top.equalTo(createTime.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        completedPersonCount.font = APPDelStatic.uiFont(with: 11)
        completedPersonCount.textColor = UIColor.gray
        // task count
        self.addSubview(taskLb)
        taskLb.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.right.equalTo(-18)
            make.top.equalTo(completedPersonCount.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        taskLb.font = APPDelStatic.uiFont(with: 11)
        taskLb.textColor = UIColor.gray
    }
    
    func setData(with: DingMeetingVModel) {
        self.stateBtn.text = with.state
        self.titleLab.text = with.title
        self.durationTime.text = with.durationTime
        self.pic.sd_setImage(with: nil, placeholderImage: UIImage(named: "richengNew.png"), options: SDWebImageOptions.lowPriority, completed: nil)
        self.createPerson.text = with.createPerson
        self.createTime.text = with.createTime
        self.completedPersonCount.text = with.completedInfo
        self.taskLb.text = with.taskCount
        self.addressLb.text = with.address
        
        let createPersonWidth = APPDelStatic.textLength(text: with.createPerson, font: APPDelStatic.uiFont(with: 11))
        self.createPerson.snp.remakeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.width.equalTo(createPersonWidth)
            make.top.equalTo(pic.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
    }
}
