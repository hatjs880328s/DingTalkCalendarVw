//
//  WorkBenchBannerVw.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/16.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation
import SnapKit

class WorkBenchBannerVw: UIView {
    
    let txtArr = ["日程","任务","会议"]
    
    var txtVwArr = [UILabel]()
    
    let scrollLine = UIView()
    
    var tapAction: ((_ index: Int,_ txt:String)->Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createVw(with fatherVw: UIView,top topVw: UIView) {
        fatherVw.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.equalTo(topVw.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(40 * APPDelStatic.sizeScale)
        }
        let leftAndRightPadding: CGFloat = 18 * APPDelStatic.sizeScale
        let eachWidth = (UIScreen.main.bounds.width - leftAndRightPadding * 2)/CGFloat(txtArr.count)
        for eachItem in 0 ... txtArr.count - 1 {
            let subVw = UILabel()
            self.addSubview(subVw)
            subVw.snp.makeConstraints { (make) in
                make.left.equalTo(CGFloat(eachItem) * eachWidth + leftAndRightPadding)
                make.bottom.equalTo(-5)
                make.width.equalTo(eachWidth)
                make.height.equalTo(25 * APPDelStatic.sizeScale)
            }
            subVw.text = txtArr[eachItem]
            subVw.textAlignment = .center
            subVw.font = APPDelStatic.uiFont(with: 13)
            subVw.tapActionsGesture {[weak self]() in
                //tap action
                self?.eachItemTap(vi: subVw)
            }
            txtVwArr.append(subVw)
            if eachItem == 0 {
                subVw.textColor = APPDelStatic.dingtalkBlue
            }
        }
        //scroll line
        self.addSubview(scrollLine)
        scrollLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.txtVwArr[0].snp.centerX)
            make.bottom.equalTo(-0.5)
            make.width.equalTo(50 * APPDelStatic.sizeScale)
            make.height.equalTo(2 * APPDelStatic.sizeScale)
        }
        scrollLine.backgroundColor = APPDelStatic.dingtalkBlue
        //bot line
        let botLine = UIView()
        self.addSubview(botLine)
        botLine.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(-0.5)
            make.right.equalTo(0)
            make.height.equalTo(0.5 * APPDelStatic.sizeScale)
        }
        botLine.backgroundColor = APPDelStatic.lightGray
    }
    
    func eachItemTap(vi: UILabel) {
        for eachItem in self.txtVwArr {
            eachItem.textColor = UIColor.black
        }
        self.scrollLine.snp.remakeConstraints { (make) in
            make.centerX.equalTo(vi.snp.centerX)
            make.bottom.equalTo(-0.5)
            make.width.equalTo(50 * APPDelStatic.sizeScale)
            make.height.equalTo(2 * APPDelStatic.sizeScale)
        }
        UIView.animate(withDuration: 0.3) {
            vi.textColor = APPDelStatic.dingtalkBlue
            self.layoutIfNeeded()
        }
        // action
        for eachItem in 0 ... self.txtVwArr.count - 1 {
            if vi === self.txtVwArr[eachItem] && self.tapAction != nil  {
                self.tapAction(eachItem,txtArr[eachItem])
            }
        }
    }
}
