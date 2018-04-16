//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPCache.swift
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

/*
 event collector : collect all AOP events
 analyze event & progress them if should [data presistence]
 analyze event & progress them if should [upload to remote server]
 */

/// linklist-item real content protocol
protocol AOPMemCacheModelProtocol {
    
    var realName:String {get set}
    var realModel: GodfatherEvent! {get set}
}

/// follow AOPMemCacheModelProtocol - linklist-item [real content]model
class AOPMemCacheModel:AOPMemCacheModelProtocol {
    
    var realName : String = "_default_str_info_"
    var realModel: GodfatherEvent!
    
    init(name:String,eventModel: GodfatherEvent) {
        if name.isEmpty {
            
        }else{
            self.realName = name
        }
        self.realModel = eventModel
    }
    
    init(name:String) {
        if name.isEmpty {
            
        }else{
            self.realName = name
        }
    }
}

/// linked list item
class AOPLinkListItem {
    
    /// content model
    var content:AOPMemCacheModelProtocol!
    
    /// before
    var beforeItem:AOPLinkListItem!
    
    /// after
    var afterItem: AOPLinkListItem!
    
    /// init just set content - before & after all is nil
    init(content: AOPMemCacheModelProtocol) {
        self.content = content
    }
    
    static func == (lsh: AOPLinkListItem,ses: AOPLinkListItem) -> Bool {
        return lsh.content.realModel == ses.content.realModel && lsh.content.realName == ses.content.realName
    }
}

/// double linked list
class AOPMemCacheList {
    
    /// current count
    var itemCount: Int = 2
    
    /// max count
    let itemMaxCount: Int = 100000
    
    /// headerItem
    var headerItem: AOPLinkListItem = AOPLinkListItem(content:AOPMemCacheModel(name: "header"))
    
    /// footerItem
    var footerItem: AOPLinkListItem = AOPLinkListItem(content:AOPMemCacheModel(name: "footer"))
    
    init() {
        self.headerItem.beforeItem = nil
        self.headerItem.afterItem = self.footerItem
        self.footerItem.beforeItem = self.headerItem
        self.footerItem.afterItem = nil
    }
    
    /// add one item - [if currentcount > maxcount first deleate last one then add it]
    ///
    /// - Parameter item: item
    func addOneItemALL(with item: AOPLinkListItem) {
        if self.itemCount >= self.itemMaxCount {
            self.deleateLastOneItemALL()
        }else{}
        item.afterItem = self.headerItem.afterItem
        item.beforeItem = self.headerItem
        self.headerItem.afterItem.beforeItem = item
        self.headerItem.afterItem = item
        self.itemCount += 1
    }
    
    /// deleate last item - [if currentcount == 2 return ; if currentcount <= maxcount return ]
    func deleateLastOneItemALL() {
        if self.itemCount <= 2 { return }
        if self.itemCount >= self.itemMaxCount {
            self.footerItem.beforeItem.beforeItem.afterItem = self.footerItem
            self.footerItem.beforeItem = self.footerItem.beforeItem.beforeItem
            self.itemCount -= 1
        }else{}
    }
    
    /// deleate last item [current count == 2 retrun ] & return the deleated item
    ///
    /// - Returns: item
    func deleateLastOneAndGetIt()->AOPLinkListItem? {
        if self.itemCount == 2 {
            return nil
        }
        let item = self.footerItem.beforeItem
        self.footerItem.beforeItem.beforeItem.afterItem = self.footerItem
        self.footerItem.beforeItem = self.footerItem.beforeItem.beforeItem
        self.itemCount -= 1
        return item
    }
    
    /// [for in] get all AOPItems
    ///
    /// - Returns: aopitem arr : Array<AOPLinkListItem>
    func getALLItemsAndDeleateALL()->Array<AOPLinkListItem> {
        var resultArr: Array<AOPLinkListItem> = Array()
        defer { deleateALLItems() }
        if self.itemCount == 2 {
            return resultArr
        }else{
            var compareItem = self.headerItem
            while (self.haveNext(item: compareItem)){
                if compareItem.beforeItem == nil {
                    compareItem = compareItem.afterItem
                    continue
                }
                resultArr.append(compareItem)
                compareItem = compareItem.afterItem
            }
            return resultArr
        }
    }
    
    /// aopitem have next ?
    ///
    /// - Parameter item: item
    /// - Returns: true : have
    func haveNext(item: AOPLinkListItem)->Bool {
        if item.afterItem != nil {
            return true
        }
        return false
    }
    
    /// if exist one item , is YES return it
    ///
    /// - Parameters:
    ///   - item: should compared item
    ///   - beItem: linked list's headerItem  [just: self.headerItem]
    /// - Returns: item?
    @discardableResult
    func isExistTheItemALL(compare item : AOPLinkListItem,beCompared beItem: AOPLinkListItem)->AOPLinkListItem? {
        if beItem.afterItem == nil  {
            return nil
        }
        if item == beItem {
            return beItem
        }else{
            return self.isExistTheItemALL(compare: item,beCompared: beItem.afterItem)
        }
    }
    
    /// deleate one item
    ///
    /// - Parameter item: item
    func deleateOneItemALL(with item: AOPLinkListItem) {
        if let existItem = self.isExistTheItemALL(compare: item, beCompared: self.headerItem) {
            existItem.beforeItem.afterItem = existItem.afterItem
            existItem.afterItem = existItem.beforeItem
            self.itemCount -= 1
        }else{}
    }
    
    /// deleate all items
    func deleateALLItems() {
        if self.itemCount == 2 { return }
        self.headerItem.afterItem = self.footerItem
        self.footerItem.beforeItem = self.headerItem
        self.itemCount = 2
    }
    
    subscript(index: Int)-> AOPLinkListItem? {
        get{
            if index != 0 { return nil }
            return self.headerItem
        }
    }
}

/// real - list [cache manager]
class AOPMemListManager: NSObject {
    
    private static var shareInstance: AOPMemListManager!
    
    public var memDL = AOPMemCacheList()
    
    private var getitemLock = NSLock()
    
    private var threadInstance: IISlinkManager = IISlinkManager(linkname: NSUUID().uuidString)
    
    private override init() {
        super.init()
    }
    
    open static func getInstance()->AOPMemListManager {
        if self.shareInstance == nil {
            self.shareInstance = AOPMemListManager()
        }
        return shareInstance
    }
    
    /// insert one item  - with thread
    func addOneEvent(event: GodfatherEvent) {
        let taskInsert = IITaskModel(taskinfo: { () -> Bool in
            let itemContent = AOPMemCacheModel(name: "", eventModel: event)
            let item = AOPLinkListItem(content: itemContent)
            
            self.memDL.addOneItemALL(with: item)
            return true
        }, taskname: NSUUID().uuidString)
        self.threadInstance.addTask(task: taskInsert)
    }
    
    func deleateOneItem(item: GodfatherEvent) {
        let itemContent = AOPMemCacheModel(name: "", eventModel: item)
        let item = AOPLinkListItem(content: itemContent)
        
        self.memDL.deleateOneItemALL(with: item)
    }
    
    func getOneItem(item: GodfatherEvent) ->GodfatherEvent? {
        let itemContent = AOPMemCacheModel(name: "", eventModel: item)
        let item = AOPLinkListItem(content: itemContent)
        
        if let resultItem = self.memDL.isExistTheItemALL(compare: item, beCompared: memDL.headerItem) {
            return resultItem.content.realModel
        }
        return nil
    }
    
    @discardableResult
    func deleateLastItemAndReturnit()->GodfatherEvent? {
        return self.memDL.deleateLastOneAndGetIt()?.content.realModel
    }
    
    /// get all real content and removeall dblist - with thread
    func getAllitemInarrAndDeleateAllitems(action: @escaping (_ info: Array<GodfatherEvent>)->Void) {
        let task = IITaskModel(taskinfo: { () -> Bool in
            var resultArr:Array<GodfatherEvent> = Array()
            let result = self.memDL.getALLItemsAndDeleateALL()
            for eachItem in result {
                resultArr.append(eachItem.content.realModel)
            }
            action(resultArr)
            return true
        }, taskname: NSUUID().uuidString)
        self.threadInstance.addTask(task: task)
    }
    
    subscript(event: GodfatherEvent) -> GodfatherEvent? {
        get{
            return self.getOneItem(item:event)
        }
    }
}





