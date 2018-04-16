//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// GCDUtility.swift
//
// Created by    Noah Shan on 2018/3/22
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

// 
import Foundation

class GCDUtility: NSObject {
    
    func barrierAction() {
        
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        
        __dispatch_async(queue) {
            for i in 0 ... 10 {
                print("one: \( i * 10 + 1 / 100)")
            }
        }
        
        __dispatch_barrier_async(queue) {
            print("top is over..")
        }
        
        
        
        __dispatch_async(queue) {
            for i in 0 ... 10 {
                print("two: \( i * 10 + 1 / 100)")
            }
        }
    }
    
    func createQueue() {
        
        let queue = DispatchQueue(label: "test-queue", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        
        let item = DispatchWorkItem(qos: DispatchQoS.background, flags: DispatchWorkItemFlags.barrier) {
            for i in 0 ... 5 {
                print("3: \(i)")
            }
        }
        
        queue.async {
            for i in 0 ... 10 {
                print("one: \( i)")
                if i == 4 {
                    //queue.suspend()
                }
            }
        }
        
        queue.async {
            for i in 0 ... 10 {
                print("one1: \( i)")
                if i == 4 {
                    //queue.suspend()
                }
            }
        }
        
        queue.async(execute: item)
        
        
        queue.async {
            for i in 0 ... 10 {
                print("two: \( i * 10 + 1 / 100)")
            }
        }
        
        queue.async {
            for i in 0 ... 10 {
                print("two1: \( i * 10 + 1 / 100)")
            }
        }
        
        
    }
    
    @available(swift, deprecated: 4, renamed: "sourceTimerWithPara(a:b:c:)")
    func sourceTimer() {
        let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.init(rawValue: 0), queue: DispatchQueue.main)
        let item  = DispatchWorkItem {
            for i in 0 ... 4 {
                print(i)
            }
        }
        timer.setEventHandler(handler: item)
        timer.setCancelHandler(handler: {
            print("over")
        })
        //立即开始 ； 2秒一次 ； 误差容忍为10毫秒
        // public func scheduleOneshot(deadline: DispatchTime, leeway: DispatchTimeInterval = default)
        //timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: 2, leeway: DispatchTimeInterval.microseconds(10))
        //timer.schedule(deadline: DispatchTime.now())
        if #available(iOS 10.0, *) {
            timer.activate()
        } else {
            timer.resume()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(10)) {
            timer.cancel()
        }
    }
    
    func semaphoreG() {
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        let semap = DispatchSemaphore(value: 2)
        
        queue.sync {
            semap.wait()
            for _ in 0 ... 30 {
                print("one1...........")
            }
             semap.signal()
        }
        
        queue.sync {
            semap.wait()
            for _ in 0 ... 30 {
                print("one2.............................")
            }
             semap.signal()
        }
        
        queue.sync {
            semap.wait()
            for _ in 0 ... 30 {
                print("one3")
            }
             semap.signal()
        }
    }
    
    func queueGroup() {
        let group = DispatchGroup()
        let overItem = DispatchWorkItem {
            print("work is over")
        }
        group.notify(queue: DispatchQueue.main, work: overItem)
        group.enter()
        DispatchQueue.global().async {
            for eachItem in 0 ... 5 {
                print("one -\(eachItem)")
            }
            DispatchQueue.main.async(execute: {
                group.leave()
            })
        }
        group.enter()
        DispatchQueue.global().async {
            for eachItem in 0 ... 5 {
                print("one2 -\(eachItem)")
            }
            
            DispatchQueue.main.async(execute: {
                group.leave()
            })
        }
        
        group.wait(timeout: DispatchTime.now() + DispatchTimeInterval.seconds(3))
    }
    
    func garrierDis() {
        let queue = DispatchQueue(label: "asdfa", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        
        queue.async {
            for eachItem in 0 ... 5 {
                print("one -\(eachItem)")
            }
        }
        queue.async {
            for eachItem in 0 ... 5 {
                print("one1 -\(eachItem)")
            }
        }
        queue.async(group: nil, qos: DispatchQoS.background, flags: DispatchWorkItemFlags.barrier) {
            for eachItem in 0 ... 5 {
                print("one-zero -\(eachItem)")
            }
        }
        queue.async {
            for eachItem in 0 ... 5 {
                print("one2 -\(eachItem)")
            }
        }
        queue.async {
            for eachItem in 0 ... 5 {
                print("one3 -\(eachItem)")
            }
        }
    }
    
    func sourceAdd() {
        let userData = DispatchSource.makeUserDataAddSource()
        var globalData: UInt = 0
        let workItem = DispatchWorkItem {
            let pendingData = userData.data
            globalData += pendingData
            print("add\(pendingData) to global is \(globalData)")
        }
        userData.setEventHandler(handler: workItem)
        userData.resume()
        let queue = DispatchQueue(label: "test-source-userdataAdd")
        queue.async {
            for _ in 0 ... 1000 {
                userData.add(data: 1)
            }
        }
        queue.async {
            for _ in 0 ... 1000 {
                userData.add(data: 1)
            }
        }
    }
}
