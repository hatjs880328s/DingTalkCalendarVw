//
//  WorkbenchBLL.swift
//  DingTalkCalendarTests
//
//  Created by Noah_Shan on 2018/4/19.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import XCTest
@testable import DingTalkCalendar

class WorkbenchBLL: XCTestCase {
    
    let workbench = WorkBench()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGTM8IsCurrentTimeZone() {
        
    }
    
    func testGet42Dates() {
        let dates = workbench.getDate(position: DingTalkPosition.middle, middleDates: nil, middleFollowDate: Date())
        //dates.dayArr
        XCTAssert(dates.dayArr.count == 42, "天数计算错误！")
        
        //XCTAssert(dates., )
        if Date().weekday == 0 {
            //XCTAssert(dates.headerCount == 7, "如果今天是")
        }
    }
    
    
}
