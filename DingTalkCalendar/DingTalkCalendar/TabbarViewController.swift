//
//  TabBarViewController.swift
//  DHBIos
//
//  Created by hanxueshi on 2017/7/11.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {
    //工作台
    let workbench = UINavigationController(rootViewController: WorkBencehViewController())
    //我的
    let myInfo = UINavigationController(rootViewController: ViewController())
    
    var badgeView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = UIColor.yellow
        self.tabBar.tintColor = UIColor.gray
        self.tabBar.isTranslucent = false
        
        // 设置控制器
        workbench.navigationBar.titleTextAttributes = [kCTForegroundColorAttributeName: UIColor.red] as [NSAttributedStringKey : Any]
        workbench.tabBarItem.title = "工作台"
        workbench.navigationBar.tintColor = UIColor.gray
        workbench.navigationBar.isTranslucent = false
        
        
        self.viewControllers = [workbench,myInfo]
        self.delegate = self
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    /**
     设置阴影
     
     - parameter offset:  偏移
     - parameter radius:  圆
     - parameter color:   颜色
     - parameter opacity: 光栅化
     */
    func dropShadow(offset:CGSize,radius:CGFloat,color:UIColor,opacity:Float){
        let path = CGMutablePath()
        path.addRect(self.tabBar.bounds)
        self.tabBar.layer.shadowPath = path;
        path.closeSubpath()
        self.tabBar.layer.shadowColor = color.cgColor
        self.tabBar.layer.shadowOffset = offset
        self.tabBar.layer.shadowRadius = radius
        self.tabBar.layer.shadowOpacity = opacity
        self.tabBar.clipsToBounds = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("tabar 销毁了")
    }
    
    
}
