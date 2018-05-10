//
//  DingMeetingVModel.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class DingMeetingVModel: NSObject {
    var formatStr = "MM月dd日 HH:mm"
    var durationTime: String = ""
    var title: String = ""
    var createPerson: String = ""
    var createTime: String = ""
    var completedInfo: String = ""
    var cellHeight:CGFloat = 0
    var state:String = "已关闭"
    var picUrl:String = ""
    var address:String = ""
    var taskCount:String = ""
    
    init(with: DingtalkMeetingModel) {
        super.init()
        self.title = with.title
        self.createPerson = "我"
        self.completedInfo = "\(with.completeCount!)/\(with.completedCount!)人已完成"
        self.picUrl = with.picUrl
        let picWidth = APPDelStatic.textLength(text: "MM月dd日 x HH:mm xx", font: APPDelStatic.uiFont(with: 11)) * 1.3
        self.cellHeight = self.picUrl == "" ? 135 : picWidth + 150
        self.createTime = with.createTime.dateToString(formatStr)
        self.taskCount = with.taskCount == 0 ? "" : "\(with.taskCount)个会议任务"
        self.address = "地点：" + with.address
        let formatDateStrStart = with.startTime.dateToString(formatStr)
        let formatDateStrEnd = with.endTime.dateToString(formatStr)
        let splitInfoStart = formatDateStrStart.split(" ")
        let splitInfoEnd = formatDateStrEnd.split(" ")
        if with.startTime.days == with.endTime.days && with.startTime.year == with.endTime.year && with.startTime.month == with.endTime.month {
            self.durationTime = splitInfoStart[0] + " " + "周\(with.startTime.week)" + " " + splitInfoStart[1] + "~" + splitInfoEnd[1]
        }else{
            let startStr = splitInfoStart[0] + " " + "周\(with.startTime.week)" + " " + splitInfoStart[1]
            let endStr = splitInfoEnd[0] + " " + "周\(with.endTime.week)" + " " + splitInfoEnd[1]
            self.durationTime =  startStr + "~" + endStr
        }
    }
    
}
