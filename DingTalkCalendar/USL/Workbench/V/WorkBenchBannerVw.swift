//
//  WorkBenchBannerVw.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/16.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class WorkBenchBannerVw: UIView {
    
    let txtArr = ["日程","任务","会议"]
    
    var txtVwArr = [UILabel]()
    
    let scrollLine = UIView()
    
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
            make.height.equalTo(45)
        }
        let leftAndRightPadding: CGFloat = 18
        let eachWidth = (UIScreen.main.bounds.width - leftAndRightPadding * 2)/3
        for eachItem in 0 ... 2 {
            let subVw = UILabel()
            self.addSubview(subVw)
            subVw.snp.makeConstraints { (make) in
                make.left.equalTo(CGFloat(eachItem) * eachWidth + leftAndRightPadding)
                make.bottom.equalTo(-5)
                make.width.equalTo(eachWidth)
                make.height.equalTo(25)
            }
            subVw.text = txtArr[eachItem]
            subVw.textAlignment = .center
            subVw.font = UIFont.systemFont(ofSize: 13)
            subVw.tapActionsGesture {[weak self]() in
                //tap action
                self?.eachItemTap(vi: subVw)
            }
            txtVwArr.append(subVw)
            if eachItem == 0 {
                subVw.textColor = UIColor.blue
            }
        }
        //scroll line
        self.addSubview(scrollLine)
        scrollLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.txtVwArr[0].snp.centerX)
            make.bottom.equalTo(-0.5)
            make.width.equalTo(50)
            make.height.equalTo(2)
        }
        scrollLine.backgroundColor = UIColor.blue
        //bot line
        let botLine = UIView()
        self.addSubview(botLine)
        botLine.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(-0.5)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
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
            make.width.equalTo(50)
            make.height.equalTo(2)
        }
        UIView.animate(withDuration: 0.3) {
            vi.textColor = UIColor.blue
            self.layoutIfNeeded()
        }
    }
}
