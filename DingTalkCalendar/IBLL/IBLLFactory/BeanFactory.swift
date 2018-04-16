//
// 
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// IBLLBeanInstance.swift
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

/*
 TODO:
 1.define the flag ,it's type IBLLOne
 2.use the flag doSomething.
 3.no other rubbish code
 4.use XML linking ibll & bll
 
 Note:
 1.BLL class must extends NSObject & interface IBLL
 */

class BeanFactory: NSObject {
    
    
    /// Use bean factory create real bll instance - type is ibll
    ///
    /// - Parameter instanceID: xml id - value
    /// - Returns: real bll instance <xml class - value>
    func create(with instanceID: String)->Any? {
        if let coName = BeanDicCenter.getInstance().beanDic[instanceID] {
            return self.swiftClassFromString(strInfo:coName)
        }else{
            // no key - value
            return nil
        }
    }
    
    /// run time create instance by str info 
    private func swiftClassFromString(strInfo: String)->Any? {
        let nameSpace =  Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let cls = NSClassFromString("\(nameSpace).\(strInfo)") as? NSObject.Type
        if cls == nil { return nil }
        return cls?.init()
    }
}
