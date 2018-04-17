//
//  DingTalkCalanderView.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/12.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import SnapKit

class DingTalkCalanderCollectionView: UIView {
    
    //let weekLineHeight: CGFloat = 35.0
    
    let normalDayLineHeight: CGFloat = 46
    
    let eachItemWidth: CGFloat =  (UIScreen.main.bounds.width - 10) / 7.0
    
    let picVwHeight: CGFloat = (UIScreen.main.bounds.width - 10.0)
    
    let eachRectPadding: CGFloat = 11
    
    var middleDateView: DingTalkCalenderView!
    
    var rightDateView: DingTalkCalenderView!
    
    var leftDateView: DingTalkCalenderView!
    
    var viewTagCounter: Int = 10
    
    /// save which view is real middle view
    var logicMiddleVw: DingTalkCalenderView!
    
    /// save which view is real left view
    var logicLeftVw: DingTalkCalenderView!
    
    /// save which view is real right view
    var logicRightVw: DingTalkCalenderView!
    
    var swipeGetDateInfo: ((_ direction: UISwipeGestureRecognizerDirection)->dingTalkTrupleViewModel?)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI-init-Progress
extension DingTalkCalanderCollectionView {
    
    /// add self to some view [step 1]
    ///
    /// - Parameter whichView: father view
    func initDTCView(with whichView: UIView,topView: UIView) {
        whichView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(normalDayLineHeight * 6)
        }
        //create month days view
        middleDateView = DingTalkCalenderView()
        leftDateView = DingTalkCalenderView()
        rightDateView = DingTalkCalenderView()
        rightDateView.alpha = 0.0
        leftDateView.alpha = 0.0
        middleDateView.backgroundColor = UIColor.white
        leftDateView.backgroundColor = UIColor.white
        rightDateView.backgroundColor = UIColor.white
        logicMiddleVw = self.middleDateView
        logicLeftVw = self.leftDateView
        logicRightVw = self.rightDateView
        self.addGesture(to: self.leftDateView)
        self.addGesture(to: self.rightDateView)
        self.addGesture(to: self.middleDateView)
    }
    
    func create3ChildView(leftDate: dingTalkTrupleViewModel,rightDate: dingTalkTrupleViewModel,middleDate: dingTalkTrupleViewModel) {
        self.middleDateView.dateInfo = middleDate
        self.leftDateView.dateInfo = leftDate
        self.rightDateView.dateInfo = rightDate
        initCreateFirstMiddleView()
    }
    
    /// init (first) create3Views
    func initCreateFirstMiddleView() {
        self.addSubview(middleDateView)
        middleDateView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.width.equalTo(picVwHeight)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        }
        self.createSamllVw(fatherVw: middleDateView, dateArr: self.middleDateView.dateInfo)
        self.addSubview(leftDateView)
        leftDateView.snp.makeConstraints { (make) in
            make.width.equalTo(picVwHeight)
            make.right.equalTo(-UIScreen.main.bounds.width + 5)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        }
        self.createSamllVw(fatherVw: leftDateView, dateArr: self.leftDateView.dateInfo)
        self.addSubview(rightDateView)
        rightDateView.snp.makeConstraints { (make) in
            make.width.equalTo(picVwHeight)
            make.left.equalTo(UIScreen.main.bounds.width - 5)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        }
        self.createSamllVw(fatherVw: rightDateView, dateArr: self.rightDateView.dateInfo)
    }
    
    func addGesture(to dateVw: UIView) {
        let leftGsture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        leftGsture.direction = .left
        dateVw.addGestureRecognizer(leftGsture)
        let rightGsture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        rightGsture.direction = .right
        dateVw.addGestureRecognizer(rightGsture)
        let topGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeTopAction))
        topGesture.direction = .up
        dateVw.addGestureRecognizer(topGesture)
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
        downGesture.direction = .down
        dateVw.addGestureRecognizer(downGesture)
    }
    
    ///create each Month vw (42 small vw)
    func createSamllVw(fatherVw: UIView,dateArr: dingTalkTrupleViewModel) {
        for line in 0 ... 5 {
            for column in 0 ... 6 {
                let smallView = DingTalkCalenderRectLabelView(fatherView: fatherVw)
                smallView.snp.remakeConstraints { (make) in
                    make.left.equalTo((CGFloat(column) * eachItemWidth) + eachRectPadding)
                    make.width.equalTo(eachItemWidth - eachRectPadding * 2)
                    make.height.equalTo(normalDayLineHeight)
                    make.top.equalTo(CGFloat(line) * normalDayLineHeight)
                }
                smallView.tag = column + (line) * 7 + viewTagCounter
                smallView.tapAction = { tag,initFirst,superView in
                    self.eachRectVwTapAction(tag: tag,initFirst: initFirst,superView: superView)
                }
            }
        }
        self.setRectVwDate(with: dateArr, to: fatherVw)
        fatherVw.alpha = 1
    }
    
    /// set date [no ui change]
    func setRectVwDate(with trupleVM: dingTalkTrupleViewModel,to fatherVw: UIView) {
        for i in self.viewTagCounter ... 41 + self.viewTagCounter {
            if let rectVw = fatherVw.viewWithTag(i) as? DingTalkCalenderRectLabelView {
                rectVw.setParameters(item: trupleVM.dayArr[i - self.viewTagCounter])
            }
        }
    }
}

// MARK: - tag-action
extension DingTalkCalanderCollectionView {
    
    /// one rect vw be selected [ use cache info ]
    func eachRectVwTapAction(tag:Int,initFirst:Bool,superView:UIView) {
        if superView == self.middleDateView {
            if initFirst {
                self.middleDateView.firstSelectedItemSetTag(tagValue: tag)
                return
            }
            if let oldRectVw = self.middleDateView.viewWithTag(self.middleDateView.beSelectedTag) as? DingTalkCalenderRectLabelView {
                oldRectVw.changeToNormal()
            }
            self.middleDateView.othersSelectedItemSetTag(tagValue: tag)
        }else if superView == self.rightDateView {
            if initFirst {
                self.rightDateView.firstSelectedItemSetTag(tagValue: tag)
                return
            }
            if let oldRectVw = self.rightDateView.viewWithTag(self.rightDateView.beSelectedTag) as? DingTalkCalenderRectLabelView {
                oldRectVw.changeToNormal()
            }
            self.rightDateView.othersSelectedItemSetTag(tagValue: tag)
        }else{
            if initFirst {
                self.leftDateView.firstSelectedItemSetTag(tagValue: tag)
                return
            }
            if let oldRectVw = self.leftDateView.viewWithTag(self.leftDateView.beSelectedTag) as? DingTalkCalenderRectLabelView {
                oldRectVw.changeToNormal()
            }
            self.leftDateView.othersSelectedItemSetTag(tagValue: tag)
        }
        (self.viewController() as! WorkBencehViewController).reloadTb()
    }
    
    /// tb-[select one calerdar item - use indexpath-row return dingtalkEvent]
    func getCellModel(with indexRow:Int)->(eventModel: DingTalkCEvent?,dateInfo: String?) {
        let selectedIndex = self.logicMiddleVw.beSelectedTag - self.viewTagCounter
        if indexRow == 0 {
            let dateInfo = self.logicMiddleVw.dateInfo.dayArr[selectedIndex].dateInfo.dateToString("MM月dd日")
            return (nil,dateInfo)
        }
        if self.logicMiddleVw.dateInfo.dayArr[selectedIndex].fireDayInfo.count >= indexRow {
            let eventmodel =  self.logicMiddleVw.dateInfo.dayArr[selectedIndex].fireDayInfo[indexRow - 1]
            return (eventmodel,nil)
        }
        return (nil,nil)
        
    }
    
    /// tb-[cell number]
    func getCellModelsCount()->Int {
        let selectedIndex = self.logicMiddleVw.beSelectedTag - self.viewTagCounter
        let count = self.logicMiddleVw.dateInfo.dayArr[selectedIndex].fireDayInfo.count
        if count == 0 { return 0}
        return  count + 1
    }
}

// MARK: - eventProgress
extension DingTalkCalanderCollectionView {
    
    //set events info with kcevent just in logicMiddlePic
    func setEvents() {
        var resultArr = [Int: Bool]()
        let middleLogic = self.logicMiddleVw!
        GCDUtils.asyncProgress(dispatchLevel: 1, asyncDispathchFunc: {
            for eachItem in 0 ..< middleLogic.dateInfo!.dayArr.count {
                if middleLogic.dateInfo!.dayArr[eachItem].isFireDay {
                    resultArr[eachItem + self.viewTagCounter] = true
                }
            }
        }) {
            for eachItem in resultArr {
                if let rectVw = middleLogic.viewWithTag(eachItem.key) as? DingTalkCalenderRectLabelView {
                    rectVw.setEventDay()
                }
            }
        }
    }
}

// MARK: - ui action [swipe action]
extension DingTalkCalanderCollectionView {
    
    /// swipe action - left
    @objc func swipeLeftAction() {
        if swipeGetDateInfo == nil { return }
        let newRighDate = swipeGetDateInfo(.left)
        if newRighDate == nil { return }
        //view change
        self.logicMiddleVw.snp.remakeConstraints({ (make) in
            make.width.equalTo(self.picVwHeight)
            make.right.equalTo(-UIScreen.main.bounds.width + 5)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        })
        self.logicRightVw.snp.remakeConstraints({ (make) in
            make.left.equalTo(5)
            make.width.equalTo(self.picVwHeight)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        })
        self.logicLeftVw.alpha = 0
        self.logicLeftVw.snp.remakeConstraints({ (make) in
            make.width.equalTo(self.picVwHeight)
            make.left.equalTo(UIScreen.main.bounds.width - 5)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        }) { (completed) in
            self.oldLogicMiddleChangeNormalAndNewLogicMiddleChangedNormal()
            self.logicLeftVw.alpha = 1
            let assertInfo = self.logicLeftVw
            self.logicLeftVw = self.logicMiddleVw
            self.logicMiddleVw = self.logicRightVw
            self.logicRightVw = assertInfo
            self.logicRightVw.dateInfo = newRighDate!
            self.setRectVwDate(with: newRighDate!, to: self.logicRightVw)
            (self.viewController() as! WorkBencehViewController).getTodayEvents()
        }
    }
    
    /// swipe action - right
    @objc func swipeRightAction() {
        if swipeGetDateInfo == nil { return }
        let newLeftDate = swipeGetDateInfo(.right)
        if newLeftDate == nil { return }
        //view change
        self.logicMiddleVw.snp.remakeConstraints({ (make) in
            make.width.equalTo(self.picVwHeight)
            make.left.equalTo(UIScreen.main.bounds.width - 5)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        })
        self.logicLeftVw.snp.remakeConstraints({ (make) in
            make.left.equalTo(5)
            make.width.equalTo(self.picVwHeight)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        })
        self.logicRightVw.alpha = 0
        self.logicRightVw.snp.remakeConstraints({ (make) in
            make.width.equalTo(self.picVwHeight)
            make.right.equalTo(-UIScreen.main.bounds.width + 5)
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        }) { (completed) in
            self.oldLogicMiddleChangeNormalAndNewLogicMiddleChangedNormal()
            self.logicRightVw.alpha = 1
            let assertInfo = self.logicRightVw
            self.logicRightVw = self.logicMiddleVw
            self.logicMiddleVw = self.logicLeftVw
            self.logicLeftVw = assertInfo
            self.logicLeftVw.dateInfo = newLeftDate!
            self.setRectVwDate(with: newLeftDate!, to: self.logicLeftVw)
            (self.viewController() as! WorkBencehViewController).getTodayEvents()
        }
    }
    
    @objc func swipeTopAction() {
        
    }
    
    @objc func swipeDownAction() {
        
    }
    
    /// move down - no ani just frame change [with beselected item]
    func moveUpWithoutAnimation() {
        
    }
    
    /// move up - no ani just frame change [with beselected item]
    func moveDownWithoutAnimation() {
        
    }
    
    /// change all Vw to normal state
    func oldLogicMiddleChangeNormalAndNewLogicMiddleChangedNormal() {
        for eachItem in [self.logicRightVw,self.logicMiddleVw,self.logicLeftVw] {
            if eachItem?.beSelectedTag == eachItem?.firstDayTag { continue }
            if let oldVw = eachItem!.viewWithTag(eachItem!.beSelectedTag) as? DingTalkCalenderRectLabelView {
                oldVw.changeToNormal()
            }
            if let newVw = eachItem!.viewWithTag(eachItem!.firstDayTag) as? DingTalkCalenderRectLabelView {
                newVw.selectOneItem()
            }
            eachItem!.beSelectedTag = eachItem!.firstDayTag
        }
    }
}
