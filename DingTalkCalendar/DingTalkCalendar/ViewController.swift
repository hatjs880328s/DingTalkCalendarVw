//
//  ViewController.swift
//  DingTalkCalendar
//
//  Created by Noah_Shan on 2018/4/16.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let con = WorkBenchViewControllerV2()
        self.navigationController?.pushViewController(con, animated: true)
    }


}

