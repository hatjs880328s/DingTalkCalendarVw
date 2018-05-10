//
//  MeetingContainerVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import UIKit

class MeetingContainerVw: UIView {
    
    var filterVw: FilterVw!
    
    var tabVw: TaskTabVw!
    
    var vm: DingtalkMeetingVM = DingtalkMeetingVM()
    
    var overVw:UIView!
    
    var filterDetailVw: FilterDetailVw!
    
    init(frame: CGRect,fatherVw: UIView,topVw: UIView) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        fatherVw.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(topVw.snp.bottom)
        }
        bindVM()
        createVw()
        actionsProgress()
    }
    
    func createVw() {
        filterVw = FilterVw(frame: CGRect.zero, fatherVw: self)
        tabVw = TaskTabVw(frame: CGRect.zero, fatherVw: self, topView: filterVw,isMeetingTAB:true)
        self.vm.getFilterInfos()
        self.vm.getCellModelsWithPage()
    }
    
    func bindVM() {
        self.vm.reloadTBAction = {[weak self]() in
            if self?.tabVw == nil || self == nil { return }
            self?.tabVw.tabVw.reloadData()
        }
        self.vm.realodFilterInfoAction = {[weak self]() in
            if self?.filterVw == nil || self == nil { return }
            self?.filterVw.setData(data: self!.vm.filterInfos)
        }
    }
    
    func showSelf() {
        self.alpha = 1
    }
    
    func hideSelf() {
        self.alpha = 0
    }
    
    /// top filter action
    func actionsProgress() {
        self.filterVw.tapActions = {[weak self]() in
            if self == nil { return }
            if self?.overVw != nil {
                self?.removeOverVw()
                self?.filterVw.setImg(isUp: false)
                return
            }
            self!.addOverVw()
            self?.filterDetailVw = FilterDetailVw(frame: CGRect.zero, topView: self!.filterVw, fatherView: self!, dataInfo: self!.vm.filterInfos,selectedIndex: self!.vm.taskFilterSelectedIndex)
            self?.detailActionProgress()
            self?.filterVw.setImg(isUp: true)
        }
    }
    
    /// detail filter action
    func detailActionProgress() {
        self.filterDetailVw.tapActions = { [weak self](strInfo , index) in
            if self == nil { return }
            self!.vm.taskFilterSelectedIndex = index
            self?.filterVw.titleLab.text = strInfo
            self?.removeOverVw()
            self?.filterVw.setImg(isUp: false)
        }
    }
    
    /// add hideVw
    private func addOverVw() {
        self.overVw = UIView()
        self.addSubview(self.overVw)
        self.overVw.snp.makeConstraints { (make) in
            make.top.equalTo(filterVw.snp.bottom)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        overVw.backgroundColor = .black
        overVw.alpha = 0.3
        // overvw tap action
        overVw.tapActionsGesture {[weak self]() in
            self?.removeOverVw()
            self?.filterVw.setImg(isUp: false)
        }
    }
    
    /// remove hideVw
    private func removeOverVw() {
        if self.overVw == nil { return }
        self.overVw.removeFromSuperview()
        self.overVw = nil
        if self.filterDetailVw == nil { return }
        self.filterDetailVw.removeFromSuperview()
        self.filterDetailVw = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init the meeting containervw fail...")
    }
    
    
}
