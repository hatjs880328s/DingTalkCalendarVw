//
//  DingtalkTaskModel.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class DingtalkTaskModel: NSObject {
    
    var startTime: Date!
    var endTime: Date!
    var title: String = ""
    var toPerson: String = ""
    var createTime: Date!
    var completedCount:Int!
    var completeCount: Int!
    var picUrl:String = "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3705843135,1644722208&fm=27&gp=0.jpg"
    
    override init() {
        super.init()
    }
    
    func setData(startTime: Date,endTime: Date,title: String,toPerson: String,createTime: Date,completedCount: Int,completeCount: Int) {
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.toPerson = toPerson
        self.createTime = createTime
        self.completedCount = completedCount
        self.completeCount = completeCount
    }
    
    
}
