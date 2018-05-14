//
//  WorkbenchVM.swift
//  DingTalkCalendarTests
//
//  Created by Noah_Shan on 2018/4/20.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import XCTest
@testable import DingTalkCalendar

class WorkbenchVM: XCTestCase {
    
    let vm = DingTalkCalanderVM()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetCurrentDates() {
        
        let trupleInfo = self.vm.getCurrentMonthDays(currentMonthDay: Date())
        
        XCTAssert(trupleInfo.left.dayArr.count == 42, "天数错误！")
        
        XCTAssert(trupleInfo.middle.dayArr.count == 42, "天数错误！")
        
        XCTAssert(trupleInfo.right.dayArr.count == 42, "天数错误！")
        
        let today = Date().days
        
        XCTAssert(trupleInfo.middle.dayArr[trupleInfo.middle.headerCount + today - 1].dateInfo.days == today, "今天日期错误！")
        
        // 自己创建日期来测试
        let todayDate = Date.from(year: 2019, month: 12, day: 31)!
        
        let newTrupleInfo = self.vm.getCurrentMonthDays(currentMonthDay: todayDate)
        
        XCTAssert(newTrupleInfo.middle.dayArr[newTrupleInfo.middle.headerCount + todayDate.days - 1].dateInfo.days == 31, "今天日期错误！")
        
        // 测试星期是否正确
        
        let todayDates = Date.from(year: 2018, month: 4, day: 20)!
        
        XCTAssert(todayDates.weekday == 6  , "星期计算错误")
        
        // 创建深度日期测试
        let deepDate = Date.from(year: 2018, month: 4, day: 20, hour: 4, min: 4, sec: 4)!
        XCTAssert(deepDate.days == 20, "日期from方法错误！")
        XCTAssert(deepDate.dateToString("yyyy-MM-dd HH:mm:ss") == "2018-04-20 04:04:04", "日期转换失败了！")
    }
    
    func testGet7Days() {
        let day = Date.from(year: 2018, month: 4, day: 20)!
        
        let calendarDay = DingTalkCalanderModel()
        
        calendarDay.setParameters(gregorionDay: 20, weekDay: 6, lunarDay: 5, isCurrentDay: true, isFirstDayCurrentMonty: false, dateInfo: day, isCurrentMonthDay: true)
        
        let followDate = DingTalkCalanderVModel(with: calendarDay)
        
        vm.getCurrentline7Days(followDate: followDate)
        
        XCTAssert(vm.smallMiddleDate.first?.dateInfo.weekday == 1, "算出来第一天应该是 2018-4-15，星期天")
        
        XCTAssert(vm.smallMiddleDate.first?.dateInfo.days == 15, "算出来第一天应该是 2018-4-15，星期天")
        
        if APPDelStatic.internationalProgress {
            XCTAssert(vm.smallMiddleDate.first?.lunarDay == "", "国际化没有阴历")
        }else{
            XCTAssert(vm.smallMiddleDate.first?.lunarDay == "三十", "算出来第一天应该是 2018-4-15，星期天,农历三十")
        }
        
    }
    
    func testSwipeLeftWith20180420() {
        
        let day = Date.from(year: 2018, month: 4, day: 20)!
        
        let calendarDay = DingTalkCalanderModel()
        
        calendarDay.setParameters(gregorionDay: 20, weekDay: 6, lunarDay: 5, isCurrentDay: true, isFirstDayCurrentMonty: false, dateInfo: day, isCurrentMonthDay: true)
        
        let followDate = DingTalkCalanderVModel(with: calendarDay)
        
        // 现获取大图的数据
        vm.getCurrentMonthDays(currentMonthDay: day)
        
        vm.getCurrentline7Days(followDate: followDate)
        
        // 左滑
        let newRightDates = self.vm.smallSwipeleft()
        
        // 新的左边的数据就是原来的中间数据
        XCTAssert(vm.smallLeftDate.first?.dateInfo.weekday == 1, "算出来第一天应该是 2018-4-15，星期天")
        
        XCTAssert(vm.smallLeftDate.first?.dateInfo.days == 15, "算出来第一天应该是 2018-4-15，星期天")
        
        if APPDelStatic.internationalProgress {
            XCTAssert(vm.smallLeftDate.first?.lunarDay == "", "国际化没有阴历")
        }else{
            XCTAssert(vm.smallLeftDate.first?.lunarDay == "三十", "算出来第一天应该是 2018-4-15，星期天,农历三十")
        }
        
        // 新中间数据是 2018-4-22 ~ 28
        XCTAssert(vm.smallMiddleDate.first?.dateInfo.weekday == 1, "算出来第一天应该是 2018-4-22，星期天")
        
        XCTAssert(vm.smallMiddleDate.first?.dateInfo.days == 22, "算出来第一天应该是 2018-4-22，星期天")
                if APPDelStatic.internationalProgress {
            XCTAssert(vm.smallMiddleDate.first?.lunarDay == "", "国际化没有阴历")
        }else{
            XCTAssert(vm.smallMiddleDate.first?.lunarDay == "初七", "算出来第一天应该是 2018-4-22，星期天,农历初七")
        }
        
        //新的右边数据第一天应该是 2018-4-29 十四 星期天
        XCTAssert(newRightDates[0].dateInfo.days == 29, "老铁，看注释")
        
        XCTAssert(newRightDates[0].dateInfo.weekday == 1, "老铁，看注释")
    }
    
    func testBigCalSwipeRight() {
        let day = Date.from(year: 2018, month: 4, day: 20)!
        
        let calendarDay = DingTalkCalanderModel()
        
        calendarDay.setParameters(gregorionDay: 20, weekDay: 6, lunarDay: 5, isCurrentDay: true, isFirstDayCurrentMonty: false, dateInfo: day, isCurrentMonthDay: true)
        
        let followDate = DingTalkCalanderVModel(with: calendarDay)
        
        // 现获取大图的数据
        vm.getCurrentMonthDays(currentMonthDay: day)
        
        vm.getCurrentline7Days(followDate: followDate)
        
        let _ = vm.swipeRight()
        
        // 当前是2018-4-20 swipe right 是三月份
        // 第一天是2018-2-25 星期天，初十 header有4天   最后一天是4-7 二十二 周六 footer有7天
        XCTAssert(self.vm.middleVMDate.trupleVM.dayArr[0].dateInfo.days == 25, "看注释，第一天是25日")
        
        XCTAssert(self.vm.middleVMDate.trupleVM.headerCount == 4, "开头有4天是其他月份的奥")
        
        XCTAssert(self.vm.middleVMDate.trupleVM.footerCount == 7, "结尾有7天是其他月份的")
    }
    
    func testGetEvents(){
        let day = Date.from(year: 2018, month: 5, day: 1)!
        
        let calendarDay = DingTalkCalanderModel()
        
        calendarDay.setParameters(gregorionDay: 1, weekDay: 3, lunarDay: 16, isCurrentDay: true, isFirstDayCurrentMonty: true, dateInfo: day, isCurrentMonthDay: true)
        
        let followDate = DingTalkCalanderVModel(with: calendarDay)
        
        // 现获取大图的数据
        vm.getCurrentMonthDays(currentMonthDay: day)
        
        vm.getCurrentline7Days(followDate: followDate)
        
        self.vm.uistate = .single
        
        // 当前是2018-5-1 劳动节 十六 周二（节日最起码有2 一个劳动节，一个青年节）[处理完毕再smallmiddledate里面]
        //创建一个expection  后边字符串属性是对这个异常的描述信息
        let exp = expectation(description: "延时测试")
        let timeOut = 10 as TimeInterval
        self.vm.getEventsFromVmDate {
            for eachItem in self.vm.smallMiddleDate {
                if eachItem.dateInfo.days == 1 {
//                    XCTAssert(eachItem.isFireDay == true, "5.1不是节？")
//                    XCTAssert(eachItem.fireDayInfo.first!.title.contains("劳动节"), "名字包含劳动节字样-有肯能不是事件的第一个，看情况吧")
                }
            }
            //异常填充
            exp.fulfill()
            
        }
        //超时处理
        waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    
    
}
