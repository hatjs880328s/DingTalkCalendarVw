//
//  IICoreExtension.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/16.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class APPDelStatic {
    
    /// 计算文字宽度
    ///
    /// - Parameters:
    ///   - text: text
    ///   - font: font
    /// - Returns: 宽度
    class func textLength(text:String,font:UIFont) -> CGFloat {
        let attributes = [kCTFontAttributeName:font]
        let leftNameSize = (text as NSString).boundingRect(with: CGSize(width:1000,height:25), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedStringKey : Any], context: nil)
        return leftNameSize.width + 5
    }
    
    static let lightGray = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    
    /// rgb(0,150,246) 
    static let dingtalkBlue = UIColor(red: 0/255, green: 150/255, blue: 246/255, alpha: 1)
    
    /// 缩放
    static let sizeScale = UIScreen.main.bounds.width / 375.0
    
    /// 顶部导状态栏高度
    static var noNaviTopDistance: CGFloat {
        var dis: CGFloat = 0
        dis = UIApplication.shared.statusBarFrame.size.height
        return dis
    }
    
    /// 根据字号和宽度比例来处理字体
    static func uiFont(with size: CGFloat) ->UIFont {
        return UIFont.systemFont(ofSize:size * sizeScale)
    }
    
    /// 是否是英文
    static var internationalProgress:Bool {
        return true
    }
}
