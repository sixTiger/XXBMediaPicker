//
//  XXBMediaGroupVC.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/21.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

public class XXBMediaGroupVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var _tableView : UITableView?
    let cellID = "XXBMediaGroupVCCell"
    lazy var mediaItemVC:XXBMediaItemVC = XXBMediaItemVC()
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("\(__FUNCTION__)")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        _initView()
        self._tableView?.reloadData()
    }
    
    //MARK:-
    //MARK: view
    
    func _initNavigation() {
        let rightItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "_dismess")
        
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func _dismess() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func _initView() {
        _tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.view.addSubview(_tableView!)
        _tableView?.delegate = self
        _tableView?.dataSource = self
        _tableView?.registerClass(XXBMediaGroupCell.self, forCellReuseIdentifier: cellID)
        _tableView?.rowHeight = 80
        
        XXBDataSouce.sharedInstance.tableView = _tableView
    }
    //MARK:-
    //MARK:tableViewDelegate && tableViewDataSouce
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return XXBDataSouce.sharedInstance.mediaTableViewDataSouceNumberOfSection(_tableView!)
    }
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return XXBDataSouce.sharedInstance.mediaTableViewDataSouce(_tableView!, numberOfRowsInSection: section)
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! XXBMediaGroupCell
        cell.title = XXBDataSouce.sharedInstance.mediaTableViewDataSouce(tableView, titleOfCellAtIndexPath: indexPath)
        cell.mediaAsset = XXBDataSouce.sharedInstance.mediaTableViewDataSouce(tableView, mediaAssetOfCellAtIndexPath: indexPath)
        return cell
    }
    
    //MARK:-
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        XXBDataSouce.sharedInstance.mediaTableViewDataSouce(tableView, didSelectCellAtIndexPath: indexPath)
        self.navigationController?.pushViewController(mediaItemVC, animated: true)
    }
    
}
