//
//  IIBaseView.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/15.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation

class IIBaseView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 11.0, *) {
            self.frame = safeAreaLayoutGuide.layoutFrame
        }
    }
}
