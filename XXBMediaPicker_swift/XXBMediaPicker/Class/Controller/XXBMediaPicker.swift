//
//  XXBMediaPicker.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/21.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

public class XXBMediaPicker: UINavigationController {
    
    lazy var mediaGroupVC: XXBMediaGroupVC = {
        return XXBMediaGroupVC()
    }()
    
    override public func viewDidLoad() {
        self.pushViewController(mediaGroupVC, animated: true)
    }
    
    override public class func initialize() {
        let barItem = UIBarButtonItem.appearance()
        let textDict:Dictionary<String,AnyObject> = [
            NSForegroundColorAttributeName:UIColor.orangeColor()];
        barItem.setTitleTextAttributes(textDict, forState: UIControlState.Normal)
        
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.orangeColor()
        var textAttrs: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        textAttrs[NSForegroundColorAttributeName] = UIColor.orangeColor()
        navBar.titleTextAttributes = textAttrs
    }
}
