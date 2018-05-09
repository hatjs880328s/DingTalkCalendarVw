//
//  DingtalkGetTask.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class DingtalkGetTask: NSObject {
    override init() {
        super.init()
    }
    
    func getDataWithPage(page:Int)->[DingtalkTaskModel] {
        var result: [DingtalkTaskModel] = []
        for eachItem in 0 ... 9 {
            let item = DingtalkTaskModel()
            item.setData(startTime: Date(), endTime: Date(), title: "测试数据\(eachItem + 1)", toPerson: "", createTime: Date(), completedCount: 8, completeCount: 4)
            result.append(item)
        }
        
        return result
    }
    
    func setDataWithModel(model: DingtalkTaskModel) {
        
    }
}
