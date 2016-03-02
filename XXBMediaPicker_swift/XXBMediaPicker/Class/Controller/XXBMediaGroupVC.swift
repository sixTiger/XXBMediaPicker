//
//  XXBMediaGroupVC.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/21.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

class XXBMediaGroupVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
 
    var _tableView : UITableView?
    let cellID = "XXBMediaGroupVCCell"
    lazy var mediaItemVC:XXBMediaItemVC = XXBMediaItemVC()
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("\(__FUNCTION__)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _initView()
    }
    
    //MARK:-
    //MARK: view
    func _initView() {
        _tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.view.addSubview(_tableView!)
        _tableView?.delegate = self
        _tableView?.dataSource = self
        _tableView?.registerClass(XXBMediaGroupCell.self, forCellReuseIdentifier: cellID)
        _tableView?.rowHeight = 80
    }
    //MARK:-
    //MARK:tableViewDelegate && tableViewDataSouce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        return cell!
    }
    
    //MARK:-
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.pushViewController(mediaItemVC, animated: true)
    }
    
}
