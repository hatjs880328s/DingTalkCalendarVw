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
    
    var topLength: CGFloat = 10 * APPDelStatic.sizeScale
    
    let normalDayLineHeight: CGFloat = 45 * APPDelStatic.sizeScale
    
    let tbReuseID:String = "workBenchReuseID"
    
    var numberOfRowInSection:Int = 0
    
    var endScrollToTop:Bool = true
    
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
        tabVw.backgroundColor = APPDelStatic.lightGray
        tabVw.delegate = self
        tabVw.dataSource = self
        tabVw.separatorStyle = .none
        tabVw.isScrollEnabled = true
        self.addGesture(fatherVw: tabVw)
    }
    
    func addGesture(fatherVw: UIView) {
        let gestureTop = UISwipeGestureRecognizer(target: self, action: #selector(innerSwipeUp))
        gestureTop.direction = .up
        fatherVw.addGestureRecognizer(gestureTop)
        let gestureDown = UISwipeGestureRecognizer(target: self, action: #selector(innerSwipeDown))
        gestureDown.direction = .down
        fatherVw.addGestureRecognizer(gestureDown)
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
            cell.textLabel?.font = APPDelStatic.uiFont(with: 12)
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
        }else if indexPath.row == self.numberOfRowInSection - 1 {
            let cell = LastCell(style: UITableViewCellStyle.default, reuseIdentifier: tbReuseID)
            cell.setDate(txt: self.getTxtWithDate())
            
            return cell
        }else{
            var cell:UITableViewCell!
            let con = (self.viewController() as! WorkBenchViewControllerV2)
            var resultDate: (eventModel: DingTalkCEvent?,dateInfo: String?)!
            if con.vm.uistate == .all {
                resultDate = (self.viewController() as! WorkBenchViewControllerV2).calendarVw.getCellModel(with: indexPath.row)
            }else{
                resultDate = (self.viewController() as! WorkBenchViewControllerV2).smallCalendarVw.getCellModel(with: indexPath.row)
            }
            if resultDate.eventModel != nil {
                cell = WorkBenchTBCell(style: UITableViewCellStyle.default, reuseIdentifier: tbReuseID)
                (cell as! WorkBenchTBCell).setDate(with: resultDate.eventModel!)
            }else{
                cell = WorkBenchNullCell(style: UITableViewCellStyle.default, reuseIdentifier: tbReuseID)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 30 * APPDelStatic.sizeScale
        }else{
            return 60 * APPDelStatic.sizeScale
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
        self.numberOfRowInSection = count
        
        return count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - inner swipe up & down
extension WorkBenchBotTbVw {
    /// swipe up
    func swipeUp(withAnimation: Bool = false) {
        self.tabVw.contentOffset = CGPoint(x: 0, y: 0)
        self.snp.remakeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom).offset(normalDayLineHeight)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        if withAnimation {
            UIView.animate(withDuration: 0.5) {
                (self.viewController() as! WorkBenchViewControllerV2).smallCalendarVw.alpha = 1
                self.layoutIfNeeded()
            }
        }else{
            (self.viewController() as! WorkBenchViewControllerV2).smallCalendarVw.alpha = 1
        }
        couldScrollTab(isCould:true)
    }
    
    /// swipe down
    func swipeDown(withAnimation: Bool = false) {
        self.tabVw.contentOffset = CGPoint(x: 0, y: 0)
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
        couldScrollTab(isCould:false)
    }
    
    /// out side swipe change self.tab could scroll [swipe down tab couldn't scroll ; swipe up tab could scroll]
    func couldScrollTab(isCould:Bool) {
        self.tabVw.isScrollEnabled = isCould
    }
    
    @objc func innerSwipeUp() {
        (self.viewController() as! WorkBenchViewControllerV2).calendarVw.swipeTopAction()
    }
    
    @objc func innerSwipeDown() {
        (self.viewController() as! WorkBenchViewControllerV2).smallCalendarVw.swipeDownAction()
    }
    
    func getTxtWithDate()->String {
        return (self.viewController() as! WorkBenchViewControllerV2).vm.getTxtFollowDate()
    }
    
    /*
     use didscroll & didenddecelerating delegate funcs progress [hidden] state swipe down
    */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            self.endScrollToTop = true
        }else{
            self.endScrollToTop = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.endScrollToTop { return }
        if scrollView.contentOffset.y < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self.innerSwipeDown()
        }
    }
}

/// events indexpath > 1
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
            make.left.equalTo(18 * APPDelStatic.sizeScale)
            make.width.equalTo(50 * APPDelStatic.sizeScale)
            make.height.equalTo(14 * APPDelStatic.sizeScale)
            make.top.equalTo(15 * APPDelStatic.sizeScale)
        }
        dateStart.font = APPDelStatic.uiFont(with: 13)
        //end date
        dateEnd.snp.makeConstraints { (make) in
            make.left.equalTo(dateStart.snp.left)
            make.width.equalTo(70 * APPDelStatic.sizeScale)
            make.height.equalTo(14 * APPDelStatic.sizeScale)
            make.top.equalTo(dateStart.snp.bottom).offset(5 * APPDelStatic.sizeScale)
        }
        dateEnd.font = APPDelStatic.uiFont(with: 11)
        dateEnd.textColor = UIColor.gray
        //image
        imagePic.snp.makeConstraints { (make) in
            make.left.equalTo(dateStart.snp.right).offset(4 * APPDelStatic.sizeScale)
            make.width.equalTo(10 * APPDelStatic.sizeScale)
            make.bottom.equalTo(dateStart.snp.bottom)
            make.height.equalTo(14 * APPDelStatic.sizeScale)
        }
        imagePic.image = UIImage(named: "survey.png")
        //title
        titleLb.snp.makeConstraints { (make) in
            make.left.equalTo(imagePic.snp.right).offset(10 * APPDelStatic.sizeScale)
            make.top.equalTo(dateStart.snp.top)
            make.height.equalTo(14 * APPDelStatic.sizeScale)
            make.width.equalTo(200 * APPDelStatic.sizeScale)
        }
        titleLb.font = APPDelStatic.uiFont(with: 13)
        //subtitle
        subTitleLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(-5 * APPDelStatic.sizeScale)
            make.right.equalTo(-18 * APPDelStatic.sizeScale)
            make.width.equalTo(200 * APPDelStatic.sizeScale)
            make.height.equalTo(15 * APPDelStatic.sizeScale)
        }
        subTitleLb.textAlignment = .right
        subTitleLb.font = APPDelStatic.uiFont(with: 11)
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

class LastCell: UITableViewCell {
    
    let txtLb = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let footerVw: UIView = UIView()
        self.addSubview(footerVw)
        footerVw.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40 * APPDelStatic.sizeScale)
        self.backgroundColor = APPDelStatic.lightGray
        
        footerVw.addSubview(txtLb)
        txtLb.snp.makeConstraints { (make) in
            make.centerX.equalTo(footerVw.snp.centerX)
            make.width.equalTo(500)
            make.centerY.equalTo(footerVw.snp.centerY)
            make.height.equalTo(14 * APPDelStatic.sizeScale)
        }
        txtLb.textAlignment = .center
        txtLb.text = ""
        txtLb.font = APPDelStatic.uiFont(with: 13)
        txtLb.textColor = UIColor.gray
    }
    
    func setDate(txt: String) {
        txtLb.text = txt
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// no events indexpath = 1
class WorkBenchNullCell: UITableViewCell {
    
    let title = UILabel()
    
    let subBtn = UIButton()
    
    let imagePic = UIImageView()
    
    let titleTxt = "提升团队效率和执行力"
    
    let btnTxt = "创建日程"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        //ceateVW
        self.addSubview(title)
        self.addSubview(subBtn)
        self.addSubview(imagePic)
        //title
        title.snp.makeConstraints { (make) in
            make.right.equalTo(-18 * APPDelStatic.sizeScale)
            make.width.equalTo(500 * APPDelStatic.sizeScale)
            make.height.equalTo(14 * APPDelStatic.sizeScale)
            make.top.equalTo(5 * APPDelStatic.sizeScale)
        }
        title.text = titleTxt
        title.font = APPDelStatic.uiFont(with: 14)
        title.textAlignment = .right
        //subtitle
        subBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-18 * APPDelStatic.sizeScale)
            make.width.equalTo(70 * APPDelStatic.sizeScale)
            make.top.equalTo(title.snp.bottom).offset(7 * APPDelStatic.sizeScale)
            make.bottom.equalTo(-7 * APPDelStatic.sizeScale)
        }
        subBtn.setTitle(btnTxt, for: UIControlState.normal)
        subBtn.setTitleColor(APPDelStatic.dingtalkBlue, for: UIControlState.normal)
        subBtn.titleLabel?.font = APPDelStatic.uiFont(with: 12)
        subBtn.layer.cornerRadius = 4
        subBtn.layer.borderColor = UIColor.gray.cgColor
        subBtn.layer.borderWidth = 0.5
        subBtn.addTarget(self, action: #selector(targetAction), for: UIControlEvents.touchUpInside)
        //image
        imagePic.snp.makeConstraints { (make) in
            make.left.equalTo(40 * APPDelStatic.sizeScale)
            make.width.equalTo(50 * APPDelStatic.sizeScale)
            make.bottom.equalTo(-5)
            make.top.equalTo(5)
        }
        imagePic.image = UIImage(named: "richengNew.png")
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
    
    @objc func targetAction() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


