//
//  TaskContainerVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import UIKit

class TaskContainerVw: UIView {
    
    var filterVw: FilterVw!
    
    var dataInfo: [String] = []
    
    var overVw:UIView!
    
    var filterDetailVw: FilterDetailVw!
    
    init(frame: CGRect,fatherVw: UIView,topView:UIView) {
        super.init(frame: frame)
        fatherVw.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        initTheVw()
        actionsProgress()
    }
    
    func initTheVw() {
        filterVw = FilterVw(frame: CGRect.zero, fatherVw: self)
        self.dataInfo = (self.viewController() as! WorkBenchViewControllerV2).taskVM.taskFilterModels()
        filterVw.setData(data: self.dataInfo)
        let _ = TaskTabVw(frame: CGRect.zero, fatherVw: self, topView: filterVw)
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
            self?.filterDetailVw = FilterDetailVw(frame: CGRect.zero, topView: self!.filterVw, fatherView: self!, dataInfo: self!.dataInfo,selectedIndex: (self!.viewController() as! WorkBenchViewControllerV2).taskVM.taskFilterSelectedIndex)
            self?.detailActionProgress()
            self?.filterVw.setImg(isUp: true)
        }
    }
    
    /// detail filter action
    func detailActionProgress() {
        self.filterDetailVw.tapActions = { [weak self](strInfo , index) in
            if self == nil { return }
            (self!.viewController() as! WorkBenchViewControllerV2).taskVM.taskFilterSelectedIndex = index
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
    
    func hideSelf() {
        self.alpha = 0
    }
    
    func showSelf() {
        self.alpha = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
