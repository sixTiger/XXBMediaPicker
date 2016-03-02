//
//  XXBDataDouce.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/2.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

public class XXBDataSouce: NSObject ,XXBMediaTableViewDataSouce{
    
    static let sharedInstance = XXBDataSouce()
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    public func mediaTableViewDataSouceNumberOfSection(tableView:UITableView) -> Int {
        return 2
    }
    
    public func mediaTableViewDataSouce(tableView:UITableView,numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}
