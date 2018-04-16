//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// SQLite3Go.swift
//
// Created by    Noah Shan on 2018/3/24
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

class SQLite3Go: NSObject {
    var createSQL = "CREATE TABLE IF NOT EXISTS T1 (NAME varchar(30) , ID varchar(15));"
    
    func createTab() {
        FMDatabaseQueuePublicUtils.executeUpdate(sql: createSQL)
    }
    
    func insertSome() {
        let sql = "insert into T1 values ( 'nihao' , '333');"
        FMDatabaseQueuePublicUtils.executeUpdate(sql: sql)
    }
    
    func getSome()->NSMutableArray {
        let sql = "select * from T1 ; "
        return FMDatabaseQueuePublicUtils.getResultWithSql(sql: sql)
    }
}
