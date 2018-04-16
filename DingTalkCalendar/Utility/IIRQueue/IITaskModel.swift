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

import UIKit
import Foundation

/// task-model
class IITaskModel:Comparable {
    
    /// task-content
    var taskContext:(()->Bool)?
    
    /// task - name  use : nsuuid().stringuuid
    var taskname:String?
    
    /// task lvl [1high-5low]
    var taskLevel:Int = 5
    
    /**
     alloc
     
     - parameter taskinfo:  content
     - parameter taskname:  name use : nsuuid().stringuuid
     - parameter taskLevel: lvl 1-5
     
     - returns: self
     */
    init(taskinfo: @escaping ()->Bool,taskname:String,taskLevel:Int = 5) {
        self.taskContext = taskinfo
        self.taskname = taskname
        self.taskLevel = taskLevel
    }
    
    /**
     execute the tasks
     */
    func exeFunc() {
        let successorFail = self.taskContext!()
        if !successorFail {
            DEBUGPrintLog("boom!")
        }
    }
    
    static func == (fis:IITaskModel,ses:IITaskModel)->Bool {
        return fis.taskname == ses.taskname
    }
    
    public static func <(lhs: IITaskModel, rhs: IITaskModel) -> Bool {
        return lhs.taskLevel < rhs.taskLevel
    }
    
    public static func <=(lhs: IITaskModel, rhs: IITaskModel) -> Bool {
        return lhs.taskLevel <= rhs.taskLevel
    }
    
    public static func >=(lhs: IITaskModel, rhs: IITaskModel) -> Bool {
        return lhs.taskLevel >= rhs.taskLevel
    }
    
    public static func >(lhs: IITaskModel, rhs: IITaskModel) -> Bool{
        return lhs.taskLevel > rhs.taskLevel
    }
    
    deinit {
        //DEBUGPrintLog("dealloc-task")
    }
}
