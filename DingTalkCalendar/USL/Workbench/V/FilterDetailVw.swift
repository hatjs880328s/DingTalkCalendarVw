//
//  FilterDetailVw.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/5/9.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import UIKit

class FilterDetailVw: UIView {
    
    var eachItemHeight:Int = 40
    
    var dataInfo: [String]!
    
    var topVw: UIView!
    
    var txtVwArr: [UILabel] = []
    
    var checkVwArr: [UIImageView] = []
    
    var tapActions: ((_ str: String,_ index: Int)->Void)!
    
    var selectedIndex: Int = 0
    
    init(frame: CGRect,topView:UIView,fatherView: UIView,dataInfo: [String],selectedIndex: Int) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        fatherView.addSubview(self)
        self.dataInfo = dataInfo
        self.topVw = topView
        self.selectedIndex = selectedIndex
        createView()
    }
    
    func createView() {
        let height = eachItemHeight * self.dataInfo.count
        self.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(self.topVw.snp.bottom)
            make.height.equalTo(height)
        }
        for eachItem in 0 ... self.dataInfo.count - 1 {
            let keyLabel = UILabel()
            self.addSubview(keyLabel)
            keyLabel.snp.makeConstraints { (make) in
                make.left.equalTo(18)
                make.top.equalTo(12 + eachItemHeight * eachItem)
                make.height.equalTo(15)
                make.right.equalTo(-30)
            }
            keyLabel.text = self.dataInfo[eachItem]
            keyLabel.font = APPDelStatic.uiFont(with: 12)
            keyLabel.tapActionsGesture {[weak self]() in
                self?.tapAction(vi: keyLabel)
            }
            self.txtVwArr.append(keyLabel)
            // bot line
            let line = UIView()
            self.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.left.equalTo(18)
                make.top.equalTo(eachItemHeight * (eachItem + 1))
                make.height.equalTo(0.5)
                make.right.equalTo(0)
            }
            line.backgroundColor = APPDelStatic.lightGray
            // selected
            let selectedVw = UIImageView()
            self.addSubview(selectedVw)
            selectedVw.snp.makeConstraints { (make) in
                make.right.equalTo(-18)
                make.top.equalTo(12 + eachItemHeight * eachItem)
                make.height.equalTo(15)
                make.width.equalTo(15)
            }
            selectedVw.image = UIImage(named: "arrowDown.png")
            selectedVw.alpha = 0
            self.checkVwArr.append(selectedVw)
            if eachItem == self.selectedIndex {
                keyLabel.textColor = APPDelStatic.dingtalkBlue
                selectedVw.alpha = 1
            }
        }
    }
    
    func tapAction(vi: UILabel) {
        for eachItem in 0 ..< self.txtVwArr.count {
            if vi === self.txtVwArr[eachItem] {
                for eachItem in self.checkVwArr {
                    eachItem.alpha = 0
                }
                self.checkVwArr[eachItem].alpha = 1
                if self.tapActions == nil { return }
                self.tapActions(vi.text!,eachItem)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
