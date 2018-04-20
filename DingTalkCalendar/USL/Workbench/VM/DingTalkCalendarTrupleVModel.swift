//
//  DingTalkCalendarTrupleVModel.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/17.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class DingTalkCalendarTrupleVModel : NSObject {
    
    var trupleVM: dingTalkTrupleViewModel!
    
    var beSelectedTag: Int = 0
    
    var firstDayTag:Int = 0
    
    let formatStr = "yyyy-MM-dd"
    
    init(with vm: dingTalkTrupleViewModel) {
        super.init()
        self.trupleVM = vm
        self.beSelectedTag = vm.headerCount
        self.firstDayTag = vm.headerCount
        
        isCurrentDay()
    }
    
    /// if today [true: firstSelected is today]
    func isCurrentDay() {
        let dateInfo = Date()
        let selfDateInfo = self.trupleVM.dayArr[self.trupleVM.headerCount].dateInfo!
        if selfDateInfo.year == dateInfo.year && selfDateInfo.month == dateInfo.month {
            for i in 0 ... self.trupleVM.dayArr.count - 1 {
                if self.trupleVM.dayArr[i].isCurrentDay {
                    self.beSelectedTag = i
                    self.firstDayTag = i
                }
            }
        }
    }
    
    func setValue(trupleVM: dingTalkTrupleViewModel) {
        self.trupleVM = trupleVM
    }
    
    func setValue(selectedIndex: Int) {
        self.beSelectedTag = selectedIndex
    }
    
    func setValue(firstDayIndex: Int ) {
        self.firstDayTag = firstDayIndex
    }
    
}
