//
//  XXBMediaPicker.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/21.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

class XXBMediaPicker: UINavigationController {

    var mediaGroupVC : XXBMediaGroupVC?
    override func viewDidLoad() {
        mediaGroupVC = XXBMediaGroupVC()
        self.addChildViewController(mediaGroupVC!)
    }    
}
