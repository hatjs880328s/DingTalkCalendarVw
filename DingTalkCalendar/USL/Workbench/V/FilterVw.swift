//
//  FilterVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import UIKit

class FilterVw: UIView {
    
    let vwHeight: CGFloat = 35
    
    var tapActions:(()->Void)!
    
    private var filterInfo: [String] = [] {
        didSet{
            self.titleLab.text = self.filterInfo[1]
            let charWidth = APPDelStatic.textLength(text: self.titleLab.text!, font: APPDelStatic.uiFont(with: 11))
            self.titleLab.snp.remakeConstraints { (make) in
                make.centerX.equalTo(self.snp.centerX)
                make.width.equalTo(charWidth)
                make.bottom.equalTo(-5)
                make.top.equalTo(5)
            }
        }
    }
    
    var selectedItem:Int = 0
    
    let titleLab = UILabel()
    
    let arrowImg = UIImageView()
    
    init(frame: CGRect,fatherVw: UIView) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        fatherVw.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(vwHeight)
        }
        initTheVw()
    }
    
    private func initTheVw() {
        titleLab.font = APPDelStatic.uiFont(with: 11)
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(150)
            make.bottom.equalTo(-5)
            make.top.equalTo(5)
        }
        titleLab.textAlignment = .center
        titleLab.tapActionsGesture { [weak self]() in
            self?.tapAction()
        }
        
        self.addSubview(arrowImg)
        arrowImg.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.right).offset(5)
            make.centerY.equalTo(titleLab.snp.centerY)
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        arrowImg.image = UIImage(named: "arrowDown.png")
        
        let botLine = UIView()
        self.addSubview(botLine)
        botLine.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
            make.bottom.equalTo(-0.5)
        }
        botLine.backgroundColor = APPDelStatic.lightGray
    }
    
    /// 设置数据源
    public func setData(data: [String]) {
        self.filterInfo = data
    }
    
    func tapAction() {
        if self.tapActions == nil { return }
        self.tapActions()
    }
    
    func setImg(isUp:Bool) {
        if isUp {
            self.arrowImg.image = UIImage(named: "arrowUp.png")
            
            return
        }
        self.arrowImg.image = UIImage(named: "arrowDown.png")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
