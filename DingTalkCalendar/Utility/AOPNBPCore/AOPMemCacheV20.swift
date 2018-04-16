//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPMemCacheV20.swift
//
// Created by    Noah Shan on 2018/3/16
// InspurEmail   shanwzh@inspur.com
// GithubAddress https://github.com/hatjs880328s
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// For the full copyright and license information, plz view the LICENSE(open source)
// File that was distributed with this source code.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
//
import Foundation

protocol IAOPMemCache:NSObjectProtocol {
    
    var eventsArr: [GodfatherEvent]! {get set}
    
    var eventsDics: [String: [GodfatherEvent]]! {get set}
    
    func each30SecsPostEventsFromArrs()
    
    func addOneItemFromNotificationCenter(item: GodfatherEvent)
    
}

class AOPMemCacheV20: NSObject,IAOPMemCache {
    
    var postCount = 10
    
    var postSecs = 30
    
    var timer: Timer!
    
    var eventsArr: [GodfatherEvent]!
    
    var eventsDics: [String : [GodfatherEvent]]!
    
    /// operate thread [global-thread]
    var memCacheThread: IISlinkManager = IISlinkManager(linkname: NSUUID().uuidString)
    
    private static var shareInstance: AOPMemCacheV20!
    
    private override init() {
        super.init()
        eventsArr = []
        eventsDics = [:]
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(postSecs), target: self, selector: #selector(AOPMemCacheV20.each30SecsPostEventsFromArrs), userInfo: nil, repeats: true)
    }
    
    /// singleInstance
    static func getInstance()->AOPMemCacheV20 {
        if shareInstance == nil {
            shareInstance = AOPMemCacheV20()
        }
        return shareInstance
    }
    
    /// when time gose 30s & arr count added to 10 progress the function
    @objc func each30SecsPostEventsFromArrs() {
        let getTask = IITaskModel(taskinfo: { () -> Bool in
            self.postDataFromArrToDic()
            return true
        }, taskname: NSUUID().uuidString)
        self.memCacheThread.addTask(task: getTask)
    }
    
    /// get data from arr - group 10
    private func postDataFromArrToDic() {
        if self.eventsArr.count == 0 { return } else { }
        var dicKey: String = NSUUID().uuidString
        var dicValue: [GodfatherEvent] = []
        for i in 0 ..< self.eventsArr.count {
            if dicValue.count < self.postCount {
                dicValue.append(self.eventsArr[i])
            }else{
                self.eventsDics[dicKey] = dicValue
                dicKey = NSUUID().uuidString
                dicValue.removeAll()
            }
        }
        if dicValue.count != 0 {
            self.eventsDics[dicKey] = dicValue
        }else{}
        self.eventsArr.removeAll()
        postInfoToDisk()
    }

    /// from notification Center add event to arr
    ///
    /// - Parameter item: event
    func addOneItemFromNotificationCenter(item: GodfatherEvent){
        let addTask = IITaskModel(taskinfo: { () -> Bool in
            self.eventsArr.append(item)
            return true
        }, taskname: NSUUID().uuidString)
        self.memCacheThread.addTask(task: addTask)
        
        if self.eventsArr.count >= self.postCount {
            self.each30SecsPostEventsFromArrs()
        }else{}
    }
    
    func postInfoToDisk() {
        GCDUtils.toMianThreadProgressSome {
            AOPDiskCache.getInstance().addItemsFromMemCache(dicData: self.eventsDics)
            self.eventsDics.removeAll()
        }
    }
}
