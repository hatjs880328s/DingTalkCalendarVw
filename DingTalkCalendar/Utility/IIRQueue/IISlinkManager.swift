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

/**
 task lvl enum
 
 - HighLevel:     high
 - NormalLevel:   normal
 - LowLevel:      low
 - VeryHighLevel: v-high
 */
enum PriorityLevel {
    case HighLevel,NormalLevel,LowLevel,VeryHighLevel
}

///  background progres tasks √
///  parameters save current task count √
///  progress one task & remove it √
///  add one task & sort task arr  √
///  interrupt the task manager
///  interrupt the executing task
///  remove the task who has no executed
///  ...
///  set task lvl √

class IISlinkManager {
    
    /// if progress task now
    var ifprogressNow = false
    
    /// recursive-lock
    let DG_LOCK = NSRecursiveLock()
    
    /// task - arr
    var TASK_ARRAY: Array<IITaskModel> = []
    
    init(linkname:String) {
        
    }
    
    /**
     start - execute
     */
    private func exeAllfunction() {
        GCDUtils.asyncProgress(dispatchLevel: 1, asyncDispathchFunc: { 
            while true {
                self.DG_LOCK.lock()
                if self.TASK_ARRAY.count != 0 {
                    //DEBUGPrintLog("\(self.TASK_ARRAY[0].taskname!)start-execute")
                    self.TASK_ARRAY[0].exeFunc()
                    self.removeOnetask(Index: 0)
                    self.DG_LOCK.unlock()
                    continue
                }else{
                    self.DG_LOCK.unlock()
                    self.ifprogressNow = false
                    return
                }
            }
        }) { }
    }
    
    /**
     add one task - then [sort the tasks]
     
     - parameter task: task
     */
    func addTask(task:IITaskModel) {
        self.DG_LOCK.lock()
        self.TASK_ARRAY.append(task)
        self.TASK_ARRAY = IIMergeSort.sort(array: self.TASK_ARRAY)
        //DEBUGPrintLog("\(task.taskname!)add over & sort over")
        self.DG_LOCK.unlock()
        if !ifprogressNow {
            ifprogressNow = true
            exeAllfunction()
        }
    }
    
    /**
     remove a task
     
     - parameter Index: task index in task - arr
     */
    func removeOnetask(Index:Int){
        if Index == 0 {
            self.TASK_ARRAY.removeFirst()
        }
    }
    
    /**
     set task lvl default is lvl 1
     
     - parameter level   : lvl
     - parameter taskName: task name (uuid)
     */
    func setPriorityLevel(level:Int,taskName:String = "") {
        self.DG_LOCK.lock()
        for (item,_) in self.TASK_ARRAY.enumerated() {
            if TASK_ARRAY[item].taskname == taskName {
                let task = TASK_ARRAY[item]
                self.TASK_ARRAY.insert(task, at: 0)
                self.TASK_ARRAY.remove(at: item + 1)
                break
            }
        }
        self.DG_LOCK.unlock()
    }
}
