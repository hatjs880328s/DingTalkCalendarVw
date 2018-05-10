//
//  DingtalkMeetingVM.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/10.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class DingtalkMeetingVM:NSObject {
    
    var cellModels:Array<DingMeetingVModel> = Array() {
        didSet{
            if self.reloadTBAction == nil { return }
            self.reloadTBAction()
        }
    }
    
    var filterInfos:[String] = [] {
        didSet{
            if self.realodFilterInfoAction == nil { return }
            self.realodFilterInfoAction()
        }
    }
    
    var reloadTBAction:(()->Void)!
    
    var realodFilterInfoAction:(()->Void)!
    
    var pageNum:Int = 0
    
    var taskFilterSelectedIndex: Int = 1
    
    override init() {
        super.init()
    }
    
    /// filter infos progress
    func getFilterInfos() {
        self.filterInfos = ["未结束的","已结束/取消/不参加的","我发出的","有任务的"]
    }
    
    /// get datas with page default is 0
    func getCellModelsWithPage() {
        let realModels = DingtalkGetMeeting().getDataWithPage(page: pageNum)
        var vms:[DingMeetingVModel] = []
        for eachItem in realModels {
            let item = DingMeetingVModel(with: eachItem)
            vms.append(item)
        }
        self.cellModels.append(contentsOf: vms)
    }
    
    /// get cellmodel with indexpath.row
    func getCellWithIndexpathrow(pathRow:Int)->DingMeetingVModel {
        return self.cellModels[pathRow]
    }
    
    
}
