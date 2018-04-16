//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPGCDExtension.swift
//
// Created by    Noah Shan on 2018/3/15
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

/// dispatch - once function
extension DispatchQueue {
    static var onceDic: [String: String] = [:]
    static func once(action:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        let taskID: String = NSUUID().uuidString
        if onceDic[taskID] != nil {
            return
        }else{
            onceDic[taskID] = "0"
        }
        action()
    }
}

class GCDUtils {
    
    /**
     delay progress - success return main thread  [seconds]
     
     - parameter delayTime:   time-second
     - parameter yourFuncton: action
     */
    class func delayProgress(delayTime:Int,yourFuncton:@escaping ()->()){
        let delay = DispatchTime.now() + DispatchTimeInterval.seconds(delayTime)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            yourFuncton()
        }
    }
    
    /// delay progress - success return main thread  [milliseconds]
    ///
    /// - Parameters:
    ///   - milliseconds:  1s = 1000ms
    ///   - yourFunc: function
    class func delayProgerssWithFloatSec(milliseconds:Int,yourFunc:@escaping ()->()) {
        let delay = DispatchTime.now() + DispatchTimeInterval.milliseconds(milliseconds)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            yourFunc()
        }
    }
    
    /**
     goto main thread
     
     - parameter youraction: action
     */
    class func toMianThreadProgressSome(youraction:@escaping ()->Void) {
        DispatchQueue.main.async {
            youraction()
        }
    }
    
    /**
     first create [new thread] async progress func background & then return the main thread
     
     - parameter dispatchLevel:       Qos   [1: high-4: low]
     - parameter asyncDispathchFunc:  action
     - parameter endMainDispatchFunc: defer in main thread do it.
     */
    class func asyncProgress(dispatchLevel:Int,asyncDispathchFunc:@escaping ()->(),endMainDispatchFunc:@escaping ()->()){
        var level:DispatchQoS.QoSClass?
        if(dispatchLevel == 1){
            level = DispatchQoS.QoSClass.userInteractive
        }else if(dispatchLevel == 2){
            level = DispatchQoS.QoSClass.userInitiated
        }else if(dispatchLevel == 3){
            level = DispatchQoS.QoSClass.utility
        }else{
            level = DispatchQoS.QoSClass.background
        }
        DispatchQueue.global(qos: level!).async {
            asyncDispathchFunc()
            DispatchQueue.main.async {
                endMainDispatchFunc()
            }
        }
    }
    
    /**
     two non-main thread progress something async - then return the main thread do something
     
     - parameter endMainDispatchFunc: main thread do it last
     - parameter asyncDispicth:       thread
     */
    class func asyncSomeProgressThenDeelInmainqueue(endMainDispatchFunc:@escaping ()->(),asyfuncOne:@escaping ()->(),asyfuncTwo:@escaping (_ actionone:()->Void)->Void){
        var flagOne = 0
        var flagTwo = 0
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            asyfuncOne()
            flagOne = 1
            if flagOne == flagTwo {
                endMainDispatchFunc()
                return
            }
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            asyfuncTwo({ () -> Void in
                flagTwo = 1
                if flagOne == flagTwo {
                    endMainDispatchFunc()
                    return
                }
            })
        }
    }
    
    /**
     threads sync progres [sync]
     some distinct thread-task put in one thread [main thread]
     
     - parameter firstDispatch:  one-task
     - parameter secondDispatch: two-task
     - parameter thirdDispatch:  three-task
     - parameter others:         others-task
     */
    class func dispatchAsyncChuan(firstDispatch:@escaping ()->(),secondDispatch:@escaping ()->(),thirdDispatch:@escaping ()->(),others:()->()...){
        let groupDispatch: DispatchGroup = DispatchGroup()
        let dispatchAsy = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        groupDispatch.enter()
        dispatchAsy.sync {
            firstDispatch()
        }
        dispatchAsy.sync {
            secondDispatch()
        }
        dispatchAsy.sync {
            thirdDispatch()
        }
        dispatchAsy.sync {
            for eachItem in others.enumerated() {
                eachItem.element()
            }
        }
        groupDispatch.leave()
    }
    
    /**
     threads async progres [async]
     
     - parameter firstDispatch:  task
     - parameter secondDispatch: task
     - parameter thirdDispatch:  task
     - parameter others:         others
     */
    class func dispatchAsyncBing(firstDispatch:@escaping ()->(),secondDispatch:@escaping ()->(),thirdDispatch:@escaping ()->(),others:()->()...){
        let groupDispatch:DispatchGroup = DispatchGroup()
        let dispatchAsy = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        groupDispatch.enter()
        dispatchAsy.async {
            firstDispatch()
        }
        dispatchAsy.async {
            secondDispatch()
        }
        dispatchAsy.async {
            thirdDispatch()
        }
        dispatchAsy.async {
            firstDispatch()
        }
        for eachitem in others.enumerated() {
            dispatchAsy.async {
                eachitem.element()
            }
        }
    }
    
    /// thread group - sync lock [one & two are all over then progress endAction]
    ///
    /// - Parameters:
    ///   - actionOne: one-task
    ///   - actionTwo: two-task
    ///   - endAction: endAction
    class func someFuncitonEndTogether(actionOne:@escaping ()->Void,actionTwo:@escaping ()->Void,endAction:()->Void) {
        let disGp = DispatchGroup()
        let disOne = DispatchQueue(label: "one")
        let itemOne = DispatchWorkItem(block: actionOne)
        disOne.async(group: disGp, execute: itemOne)
        
        let disTwo = DispatchQueue(label: "two")
        let itemTwo = DispatchWorkItem(block: actionTwo)
        disTwo.async(group: disGp, execute: itemTwo)
        
        disGp.wait()
        endAction()
    }
}
