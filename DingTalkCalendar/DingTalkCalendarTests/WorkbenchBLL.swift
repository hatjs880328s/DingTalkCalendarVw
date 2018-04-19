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
        let dateLocal = self.workbench.getCurrentData(Date())
        let zone = Date()
        dateLocal.distance(to: zone)
        print(zone)
    }
    
    
    
}
