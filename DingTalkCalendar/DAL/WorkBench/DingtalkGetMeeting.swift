//
//  DingtalkGetMeeting.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/10.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class DingtalkGetMeeting: NSObject {
    override init() {
        super.init()
    }
    
    func getDataWithPage(page:Int)->[DingtalkMeetingModel] {
        var result: [DingtalkMeetingModel] = []
        for _ in 0 ... 9 {
            let item = DingtalkMeetingModel()
            item.setData(startTime: Date(), endTime: Date(), title: "meeting测试数据", createPerson: "我", createTime: Date(), completedCount: 9, completeCount: 8, address: "南侧会议室", taskCount: 2)
            result.append(item)
        }
        
        return result
    }
    
    func setDataWithModel(model: DingtalkMeetingModel) {
        
    }
}
