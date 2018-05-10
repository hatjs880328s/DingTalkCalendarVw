//
//  DingtaskVModel.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class DingtaskVModel: NSObject {
    var formatStr = "MM月dd日 HH:mm"
    var startTime: String = ""
    var endTime: String = ""
    var title: String = ""
    var toPerson: String = ""
    var createTime: String = ""
    var completedInfo: String = ""
    var cellHeight:CGFloat = 0
    var state:String = "已关闭"
    var picUrl:String = ""
    
    init(with: DingtalkTaskModel) {
        super.init()
        self.title = with.title
        let formatDateStr = with.endTime.dateToString(formatStr)
        let splitInfo = formatDateStr.split(" ")
        self.endTime = splitInfo[0] + " " + "周\(with.endTime.week)" + " " + splitInfo[1] + " " + "截止"
        self.toPerson = "我分配的"
        self.completedInfo = "\(with.completeCount!)/\(with.completedCount!)人已完成"
        self.picUrl = with.picUrl
        let picWidth = APPDelStatic.textLength(text: "MM月dd日 x HH:mm xx", font: APPDelStatic.uiFont(with: 11)) * 1.3
        self.cellHeight = self.picUrl == "" ? 95 : picWidth + 110
        self.createTime = with.createTime.dateToString(formatStr)
    }
    
}
