//
//  ViewController.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/21.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let rightItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "p_open")
        
        self.navigationItem.rightBarButtonItem = rightItem
    }
    func p_open(){
        self.navigationController!.presentViewController(XXBMediaPicker(), animated: true) { () -> Void in
            print("opened")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

