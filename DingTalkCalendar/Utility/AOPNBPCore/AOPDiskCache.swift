//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPDiskCache.swift
//
// Created by    Noah Shan on 2018/3/14
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
import UIKit

/*
 event collector : collect all AOP events
 analyze event & progress them if should [data presistence]
 analyze event & progress them if should [upload to remote server]
 */
class AOPDiskCache: NSObject {
    
    var postCount = 10
    
    var postSecs = 30
    
    private static var shareInstance :AOPDiskCache!
    
    var dics: [String : [GodfatherEvent]] = [:]
    
    let diskCacheThread: IISlinkManager = IISlinkManager(linkname: NSUUID().uuidString)
    
    var timer: Timer!
    
    private var usKeyStr = "AOP_NBP_EVENTS_UDKEY"
    
    let eventJoinedStr = "-"
    
    private override init() {
        super.init()
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.postSecs), target: self, selector: #selector(AOPDiskCache.each30SecsPostEventsFromDic), userInfo: nil, repeats: true)
        
        if UserDefaults.standard.object(forKey: self.usKeyStr) == nil {
            UserDefaults.standard.set("", forKey: self.usKeyStr)
        }
    }
    
    public static func getInstance()->AOPDiskCache {
        if shareInstance == nil {
            shareInstance = AOPDiskCache()
        }
        return shareInstance
    }
    
    /// add data from memcache
    func addItemsFromMemCache(dicData items : [String: [GodfatherEvent]]) {
        let addTask = IITaskModel(taskinfo: { () -> Bool in
            for eachKey in items.keys {
                self.dics[eachKey] = items[eachKey]
            }
            self.each30SecsPostEventsFromDic()
            DEBUGPrintLog("-disk had received data-")
            
            return true
        }, taskname: NSUUID().uuidString)
        self.diskCacheThread.addTask(task: addTask)
        
    }

    /// when time gose 30s & arr count added to 10 progress the function
    @objc func each30SecsPostEventsFromDic() {
        let getTask = IITaskModel(taskinfo: { () -> Bool in
            self.postDataToDisk()
            return true
        }, taskname: NSUUID().uuidString)
        self.diskCacheThread.addTask(task: getTask)
    }
    
    //MARK: set---------
    
    /// add data to disk
    private func postDataToDisk() {
        if self.dics.count == 0 { return }else {}
        var longStrComponentsByEachKey = UserDefaults.standard.string(forKey: self.usKeyStr)
        for (eachKey,eachValue) in self.dics {
            longStrComponentsByEachKey! += eachKey
            self.saveData(key: eachKey, value: eachValue)
        }
        UserDefaults.standard.set(longStrComponentsByEachKey, forKey: self.usKeyStr)
        self.dics.removeAll()
        DEBUGPrintLog("-saved to disk-")
    }
    
    /// real save function
    private func saveData(key: String,value: [GodfatherEvent]) {
        var eventStr = String()
        for eachItem in value {
            eventStr += (eachItem.description)
        }
        UserDefaults.standard.set(eventStr, forKey: key)
    }
    
    //MARK: get---------
    
    /// get all key's key
    func getAllSavedKeys() ->Array<String>?{
        if let udkey = UserDefaults.standard.string(forKey: self.usKeyStr){
            let arr:Array<String> = udkey.subStrEachParameterCharacter(countPara: NSUUID().uuidString.lengthOfBytes(using: String.Encoding.utf8))
            return arr
        }
        return nil
    }
    
    /// get [events] from userdefaults by key's key
    func getDataWithFirstLevelKey(key: String)->String? {
        if UserDefaults.standard.string(forKey: key) != nil {
            return UserDefaults.standard.string(forKey: key)
        }else{
            return nil
        }
    }
    
    //MARK: deleate---------
    
    /// deleate global key & ud key
    func deleateDiskDataWithFirstLevelKey(key: String) {
        if let udkey = UserDefaults.standard.string(forKey: self.usKeyStr){
            let endStr = udkey.replacingOccurrences(of: udkey as String, with: String())
            UserDefaults.standard.set(endStr, forKey: self.usKeyStr)
            UserDefaults.standard.removeObject(forKey: udkey as String)
        }
    }
}
