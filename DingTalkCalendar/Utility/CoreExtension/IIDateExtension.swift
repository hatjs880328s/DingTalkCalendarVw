//
//  MyDateExtension.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/7.
//  Copyright © 2015年 东正. All rights reserved.
//

import UIKit

extension Foundation.Date{
    
    ///强制转换成字符串
    func toString()->String{
        return String(describing: self)
    }
    
    ///比较时间
    func dateCompare(_ compareData:Foundation.Date)->Bool{
        let now = self.timeIntervalSince(compareData)
        if(now > 0){
            
            return true
        }else{
            
            return false
        }
    
    }
    
    ///更换日期格式
    func changeFormate(_ newFormate:String,oldFormate:String)->Foundation.Date{

        let str = self.dateToString(oldFormate)
        return str.dateValue(newFormate)!
        
    }
    ///提前几天
    func beforeDate(_ befor:Int)->Foundation.Date{
        let time = self.timeIntervalSince1970
        let newDate = Foundation.Date(timeIntervalSince1970: time - Double(befor * 3600 * 24))
        return newDate
    }
    ///推迟几天
    func nextDate(_ befor:Int)->Foundation.Date{
        let time = self.timeIntervalSince1970
        let newDate = Foundation.Date(timeIntervalSince1970: time + Double(befor * 3600 * 24))
        return newDate
    }
    
    ///设置格式
    func dateFormate(_ formate:String)->Foundation.Date{
        let formats = DateFormatter()
        formats.dateFormat = formate
        formats.timeZone = .current
        let str = formats.string(from: self)
        let newStr = str.substringToIndex(formate.length)
        return newStr.dateValue(formate)!
    }
    
    
    /**
    在自身上添加时间
    
    - parameter seconds: 秒
    - parameter minutes: 分钟
    - parameter hours: 小时
    - parameter days: 天
    - parameter weeks: 周
    - parameter months: 月
    - parameter years: 年
    - returns: 当前时间加上参数之后的时间
    */
    public func add(_ seconds: Int = 0, minutes: Int = 0, hours: Int = 0, days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> Foundation.Date {
        let calendar = Calendar.current
        
        let version = floor(NSFoundationVersionNumber)
        
        if version <= NSFoundationVersionNumber10_9_2 {
            var component = DateComponents()
            (component as NSDateComponents).setValue(seconds, forComponent: .second)
            
            var date : Foundation.Date! = (calendar as NSCalendar).date(byAdding: component, to: self, options: [])!
            component = DateComponents()
            (component as NSDateComponents).setValue(minutes, forComponent: .minute)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            
            component = DateComponents()
            (component as NSDateComponents).setValue(hours, forComponent: .hour)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            
            component = DateComponents()
            (component as NSDateComponents).setValue(days, forComponent: .day)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            
            component = DateComponents()
            (component as NSDateComponents).setValue(weeks, forComponent: .weekOfMonth)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            
            component = DateComponents()
            (component as NSDateComponents).setValue(months, forComponent: .month)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            
            component = DateComponents()
            (component as NSDateComponents).setValue(years, forComponent: .year)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            return date
        }
        
        var date : Foundation.Date! = (calendar as NSCalendar).date(byAdding: .second, value: seconds, to: self, options: [])
        date = (calendar as NSCalendar).date(byAdding: .minute, value: minutes, to: date, options: [])
        date = (calendar as NSCalendar).date(byAdding: .day, value: days, to: date, options: [])
        date = (calendar as NSCalendar).date(byAdding: .hour, value: hours, to: date, options: [])
        date = (calendar as NSCalendar).date(byAdding: .weekOfMonth, value: weeks, to: date, options: [])
        date = (calendar as NSCalendar).date(byAdding: .month, value: months, to: date, options: [])
        date = (calendar as NSCalendar).date(byAdding: .year, value: years, to: date, options: [])
        return date
    }
    
    
    /// 获取阴历的日子
    ///
    /// - Returns: int
    func getLunarDayInfo()-> Int{
        let calender = Calendar(identifier: Calendar.Identifier.chinese)
        return calender.component(.day, from: self)
    }
    
    /**
    增加秒
    
    - parameter seconds: 需要增加的秒
    - returns: 增加秒后的时间
    */
    public func addSeconds (_ seconds: Int) -> Foundation.Date {
        return add(seconds)
    }
    
    /**
    增加分钟
    
    - parameter minutes: 需要增加的分钟
    - returns: 增加分钟后的时间
    */
    public func addMinutes (_ minutes: Int) -> Foundation.Date {
        return add(minutes: minutes)
    }
    
    /**
    增加小时
    
    - parameter hours: 小时
    - returns: 增加小时后的时间
    */
    public func addHours(_ hours: Int) -> Foundation.Date {
        return add(hours: hours)
    }
    
    /**
    增加天
    
    - parameter days: 天数
    - returns: 增加天后的时间
    */
    public func addDays(_ days: Int) -> Foundation.Date {
        return add(days: days)
    }
    
    /**
    增加星期
    
    - parameter weeks: 周数
    - returns: 增加周数之后的时间
    */
    public func addWeeks(_ weeks: Int) -> Foundation.Date {
        return add(weeks: weeks)
    }
    
    
    /**
    增加月
    
    - parameter months: 月数
    - returns: 增加月之后的时间
    */
    
    public func addMonths(_ months: Int) -> Foundation.Date {
        return add(months: months)
    }
    
    /**
    增加年
    
    - parameter years: 年数
    - returns: 增加年后的时候
    */
    public func addYears(_ years: Int) -> Foundation.Date {
        return add(years: years)
    }
    
    /**
    检查相等
    
    - parameter date: 需要比较的时间
    - returns: True 相等
    */
    func isEqualsTo(_ date: Foundation.Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedSame
    }
    
    /**
    检查自己是不是在输入时间之后
    
    - parameter date: 需要比较的时间
    - returns: True 自身在输入之后
    */
    public func isAfter(_ date: Foundation.Date) -> Bool{
        return (self.compare(date) == ComparisonResult.orderedDescending)
    }
    
    /**
    检查自己是不是在输入时间之后
    
    - parameter date: 需要比较的时间
    - returns: True 自身在输入之前
    */
    public func isBefore(_ date: Foundation.Date) -> Bool{
        return (self.compare(date) == ComparisonResult.orderedAscending)
    }
    
    /**
    年
    */
    public var year : Int {
        get {
            return getComponent(.year)
        }
    }
    
    /**
    月
    */
    public var month : Int {
        get {
            return getComponent(.month)
        }
    }
    
    /**
    这个星期的周几  请注意这是从周日是第一天开始算的！
    */
    public var weekday : Int {
        get {
            return getComponent(.weekday)
        }
    }
    
    /// 这是周几
    public var week : String{
        get{
            if(self.weekday == 1){
                return "日"
            }
            if(self.weekday == 2){
                return "一"
            }
            if(self.weekday == 3){
                return "二"
            }
            if(self.weekday == 4){
                return "三"
            }
            if(self.weekday == 5){
                return "四"
            }
            if(self.weekday == 6){
                return "五"
            }
            if(self.weekday == 7){
                return "六"
            }
            return "未知星期"
        }
    }
    
    /**
    这个星期是这个月的第几个星期  
    */
    public var weekMonth : Int {
        get {
            return getComponent(.weekOfMonth)
        }
    }
    
    
    /**
    天
    */
    public var days : Int {
        get {
            return getComponent(.day)
        }
    }
    
    /**
    小时
    */
    public var hours : Int {
        
        get {
            return getComponent(.hour)
        }
    }
    
    /**
    分钟
    */
    public var minutes : Int {
        get {
            return getComponent(.minute)
        }
    }
    
    /**
    秒
    */
    public var seconds : Int {
        get {
            return getComponent(.second)
        }
    }
    
    /**
    当月有几天
    */
    public func numOfDayFormMouth()->Int{
        let calendar = Calendar.current
        let range = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)

        return range.length
    }
    
    /**
    今年的当月有几天
    */
    public func numOfDayFormMouthInTheNowYear(_ mouth:Int)->Int{
        let newDateStr = "\(self.year)-\(mouth)"
        let newDate = newDateStr.toDate("yyyy-MM")
        return (newDate?.numOfDayFormMouth())!
    }
    
    /// 返回某一年的某一个月有多少天
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns:  日
    public func numberOfDaysFromMonthInSomeYear(year:Int,month:Int) ->Int {
        let newDateStr = "\(year)-\(month)"
        let newDate = newDateStr.toDate("yyyy-MM")
        return (newDate?.numOfDayFormMouth())!
    }
    
    /**
   返回根据历法所取到的值
    
    - parameter component: NSCalendarUnit 历法
    - returns: 根据历法所需要的值
    */
    
    public func getComponent (_ component : NSCalendar.Unit) -> Int {
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components(component, from: self)
            var com:Calendar.Component!
            switch component {
            case NSCalendar.Unit.year:
                com = .year
            case NSCalendar.Unit.month:
                com = .month
            case NSCalendar.Unit.weekday:
                com = .weekday
            case NSCalendar.Unit.weekOfMonth:
                com = .weekOfMonth
            case NSCalendar.Unit.day:
                com = .day
            case NSCalendar.Unit.hour:
                com = .hour
            case NSCalendar.Unit.minute:
                com = .minute
            case NSCalendar.Unit.second:
                com = .second
                
            default:
                assert(true)
            }
            return components.value(for: com)!
    }
    
    /// 根据输入的年月日生成日期对象
    ///
    /// :param year
    /// :param month
    /// :param day
    /// :return Date
    public static func from(year: Int, month: Int, day: Int) -> Foundation.Date? {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
       let IdentifierGregorian = Calendar.Identifier.gregorian
        let gregorianC = Calendar(identifier: IdentifierGregorian)
        return gregorianC.date(from: c)
    }
    
    /// 根据unix时间戳生成日期对象
    ///
    /// :param unix timestamp
    /// :return Date
    public static func from(unix: Double) -> Foundation.Date {
        return Foundation.Date(timeIntervalSince1970: unix)
    }
    
    /// 基于格式解析日期并返回一个新的日期对象
    ///
    /// :param dateStr String version of the date
    /// :param format 默认的格式
    /// :return Date
    public static func parse(_ dateStr: String, format: String = "yyyy-MM-dd") -> Foundation.Date {
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone.current
        dateFmt.dateFormat = format
        return dateFmt.date(from: dateStr)!
    }
    
    /// 通过日期获取时间戳活着返回当前的时间戳
    ///
    /// :param date
    /// :return Double
    public static func unix(_ date: Foundation.Date = Foundation.Date()) -> Double {
        return date.timeIntervalSince1970 as Double
    }
    

}
extension Foundation.Date: Strideable {
    /**
    返回到某一时间点的时间间距
    
    - parameter other:时间点
    - returns: 时间间隔
    */
    public func distance(to other: Foundation.Date) -> TimeInterval {
        return other - self
    }
    /**
    快进秒数
    
    - parameter other:需要快进的秒
    - returns: 快进之后的时间
    */
    public func advanced(by n: TimeInterval) -> Date {
        return type(of: self).init(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate + n)
    }
}
// MARK: Arithmetic
/// 加
func +(date: Foundation.Date, timeInterval: Int) -> Foundation.Date {
    return date.addingTimeInterval(TimeInterval(timeInterval))
}
/// 减
func -(date: Foundation.Date, timeInterval: Int) -> Foundation.Date {
    return date.addingTimeInterval(TimeInterval(-timeInterval))
}

func +=(date: inout Foundation.Date, timeInterval: Int) {
    date = date + timeInterval
}

func -=(date: inout Foundation.Date, timeInterval: Int) {
    date = date - timeInterval
}

func +(date: Foundation.Date, timeInterval: Double) -> Foundation.Date {
    return date.addingTimeInterval(TimeInterval(timeInterval))
}

func -(date: Foundation.Date, timeInterval: Double) -> Foundation.Date {
    return date.addingTimeInterval(TimeInterval(-timeInterval))
}

func +=(date: inout Foundation.Date, timeInterval: Double) {
    date = date.addingTimeInterval(TimeInterval(timeInterval))
}

func -=(date: inout Foundation.Date, timeInterval: Double) {
    date = date.addingTimeInterval(TimeInterval(-timeInterval))
}

func -(date: Foundation.Date, otherDate: Foundation.Date) -> TimeInterval {
    return date.timeIntervalSince(otherDate)
}

public func ==(lhs: Foundation.Date, rhs: Foundation.Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedSame
}


public func <(lhs: Foundation.Date, rhs: Foundation.Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedAscending
}

public typealias Date = Foundation.Date
