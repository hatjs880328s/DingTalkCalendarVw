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
    
    init(with vm: dingTalkTrupleViewModel) {
        super.init()
        self.trupleVM = vm
        self.beSelectedTag = vm.headerCount
        self.firstDayTag = vm.headerCount
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
