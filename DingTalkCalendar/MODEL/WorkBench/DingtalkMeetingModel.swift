//
//  DingtalkMeetingModel.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class DingtalkMeetingModel: NSObject {
    
    var startTime: Date!
    var endTime: Date!
    var title: String = ""
    var createPerson: String = ""
    var createTime: Date!
    var completedCount:Int!
    var completeCount: Int!
    var picUrl:String = "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3705843135,1644722208&fm=27&gp=0.jpg"
    var address:String = ""
    var taskCount:Int = 0
    
    override init() {
        super.init()
    }
    
    func setData(startTime: Date,endTime: Date,title: String,createPerson: String,createTime: Date,completedCount: Int,completeCount: Int,address:String,taskCount:Int) {
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.createPerson = createPerson
        self.createTime = createTime
        self.completedCount = completedCount
        self.completeCount = completeCount
        self.address = address
        self.taskCount = taskCount
    }
    
    
}
