//
//  XXBMediaTableViewDataSouce.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/2.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

public protocol XXBMediaTableViewDataSouce : NSObjectProtocol {
    
    @available(iOS 2.0, *)
    func mediaTableViewDataSouce(tableView:UITableView , numberOfRowsInSection section: Int) -> Int
    
    @available(iOS 2.0, *)
    func mediaTableViewDataSouceNumberOfSection(tableView:UITableView) -> Int
    
    @available(iOS 2.0, *)
    func mediaTableViewDataSouce(tableView:UITableView , titleOfCellAtIndexPath indexPath: NSIndexPath) -> String
    
    @available(iOS 2.0, *)
    func mediaTableViewDataSouce(tableView:UITableView , mediaAssetOfCellAtIndexPath indexPath: NSIndexPath) -> XXBMediaAssetDataSouce?
    
    @available(iOS 2.0, *)
    func mediaTableViewDataSouce(tableView:UITableView , didSelectCellAtIndexPath indexPath: NSIndexPath)
    
}

