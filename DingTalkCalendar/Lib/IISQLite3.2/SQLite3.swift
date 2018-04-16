//
//  FMDatabaseQueuePublicUtils
//  FMDatabaseQueuePublicUtils
//
//  Created by Noah_Shan on 2018/3/24.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import UIKit

class FMDatabaseQueuePublicUtils: NSObject {
    static var queueDB:FMDatabaseQueue!
    static var dbname = "InspurInterAOPNBPManager.sqlite"
    
    class func InitTheDb()->Bool{
        if queueDB != nil { return true}
        if(queueDB == nil){
            do {
                let pathNew = try FileManager.default.url(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(dbname)
                queueDB = FMDatabaseQueue(url: pathNew)
                return true
            }catch{
                return false
            }
        }
        return true
    }
    
    /// use safety thread QUEUE & progress sql with transcation  :) - if fail rollback
    class func executeUpdate(sql: String){
        if !InitTheDb() { return }
        queueDB.inTransaction { (db, rollback) in
            defer {db.commit() ; db.close()}
            do {
                for eachItem in sql.components(separatedBy: ";") {
                    if eachItem.isEmpty {continue}
                    try db.executeUpdate(eachItem, values: nil)
                }
            }catch {
                rollback.pointee = true
            }
        }
    }
    
    /// execute query  then return Array result like 'select * from xxx where ?'
    class func getResultWithSql(sql: String)->NSMutableArray {
        let resultLast = NSMutableArray()
        if !InitTheDb() { return resultLast }
        
        queueDB.inDatabase({ (db) in
            defer { db.close() }
            do {
                let resultSet = try db.executeQuery(sql, values: nil)
                let count = resultSet.columnCount
                while (resultSet.next()) {
                    let dic  = NSMutableDictionary()
                    for i in 0  ..< Int(count)  {
                        var columnName:NSString!
                        columnName = resultSet.columnName(for: Int32(i))! as NSString
                        let obj: AnyObject! = resultSet.object(forColumn: columnName as String) as AnyObject!
                        dic.setObject(obj, forKey: columnName)
                    }
                    resultLast.add(dic)
                }
            } catch {}
        })
        return resultLast
    }
    
}

