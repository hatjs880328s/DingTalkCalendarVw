//
//  DingtalkTaskVM.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class DingtalkTaskVM: NSObject {
    
    let taskDal = DingtalkGetTask()
    
    var taskModels: [DingtaskVModel] = []
    
    var taskFilterSelectedIndex: Int = 1
    
    override init() {
        super.init()
    }
}

// MARK: - filter data progress
extension DingtalkTaskVM {
    func taskFilterModels()->[String:String] {
        let models = ["未完成的":"","已完成的":"","我发出的":"","我执行的":"","抄送我的":""]
        
        return models
    }
    
    func taskFilterModels()->[String] {
        return ["未完成的","已完成的","我发出的","我执行的","抄送我的"]
    }
}

// MARK: - tableview-data progress
extension DingtalkTaskVM {
    
    func getVMWithPage(page: Int) {
        let data = taskDal.getDataWithPage(page: page)
        for eachItem in data {
            let item = DingtaskVModel(with: eachItem)
            self.taskModels.append(item)
        }
    }
    
    func getVMCount()->Int {
        return self.taskModels.count
    }
    
    func getVModelWithIndex(indexPathRow:Int)->DingtaskVModel {
        return self.taskModels[indexPathRow]
    }
    
}
