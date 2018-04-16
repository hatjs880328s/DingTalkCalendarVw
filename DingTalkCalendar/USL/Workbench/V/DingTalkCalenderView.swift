//
//  DingTalkCalenderView.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/13.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


class DingTalkCalenderView: UIView {
    
    var dateInfo: dingTalkTrupleViewModel!
    
    var beSelectedTag: Int = 0
    
    var firstDayTag:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setValue(dateInfo: dingTalkTrupleViewModel) {
        self.dateInfo = dateInfo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func firstSelectedItemSetTag(tagValue: Int) {
        self.firstDayTag = tagValue
        self.beSelectedTag = tagValue
    }
    
    func othersSelectedItemSetTag(tagValue: Int) {
        self.beSelectedTag = tagValue
    }
}
