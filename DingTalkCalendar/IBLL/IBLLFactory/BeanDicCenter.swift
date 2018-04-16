//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// IBLLBeanFactory.swift
//
// Created by    Noah Shan on 2018/3/29
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

/// Bean factory - progress xml file & get all bean
/// (don't create bean's instance,just get xml str info)
class BeanDicCenter: NSObject {
    
    let keyStr = "_id"
    
    let valueStr = "_class"
    
    private static var shareInstance: BeanDicCenter!
    
    var xmlHandler: XMLHandler! = XMLHandler()
    
    public var beanDic:Dictionary<String,String> = [:]
    
    private override init() { super.init() }
    
    public static func getInstance()->BeanDicCenter {
        if shareInstance == nil {
            shareInstance = BeanDicCenter()
        }
        return shareInstance
    }
    
    /// start - service [bean factory start service]
    public func startService() {
        let xmlBeanArr = self.xmlHandler.xmlFileStart()
        self.loopProgress(xmlArr: xmlBeanArr)
        self.xmlHandler = nil
    }
    
    private func loopProgress(xmlArr info: NSArray) {
        for eachXmlBean in info {
            if let xmlDic = eachXmlBean as? NSDictionary {
                self.analyzeEachBean(with: xmlDic)
            }else{
                DEBUGPrintLog("\(eachXmlBean)")
            }
        }
        DEBUGPrintLog("-- the xml file progress over --")
    }
    
    private func analyzeEachBean(with dicInfo: NSDictionary) {
        self.beanDic[dicInfo[self.keyStr] as! String] = dicInfo[self.valueStr] as? String
    }
}
