//
//  XXBMediaItemVC.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/1.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

public class XXBMediaItemVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var _collectionView : UICollectionView?
    let nomalCellID = "XXBMediaItemVCNomalCell"
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.yellowColor()
        _initView();
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func _initView() {
        
        let layout = UICollectionViewFlowLayout()
        let screenWidth = min(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
        layout.minimumInteritemSpacing = 4;
        layout.minimumLineSpacing = 4;
        let itemWidth = (screenWidth - layout.minimumInteritemSpacing)/4.0 - layout.minimumInteritemSpacing;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.sectionInset = UIEdgeInsetsMake(layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumLineSpacing, layout.minimumInteritemSpacing);
        layout.footerReferenceSize = CGSizeMake(300.0, 50.0);
        _collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: layout)
        XXBDataSouce.sharedInstance.collectionView = _collectionView
        _collectionView?.registerClass(XXBMediaItemNomalCell.self, forCellWithReuseIdentifier:nomalCellID)
        self.view.addSubview(_collectionView!)
        _collectionView?.delegate = self
        _collectionView?.dataSource = self
    }

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return XXBDataSouce.sharedInstance.mediaCollectionViewDataSouceNumberOfSection(collectionView)
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return XXBDataSouce.sharedInstance.mediaCollectionViewDataSouce(collectionView, numberOfRowsInSection: section)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(nomalCellID, forIndexPath: indexPath) as! XXBMediaItemNomalCell
        cell.mediaAsset = XXBDataSouce.sharedInstance.mediaCollectionViewDataSouce(collectionView, mediaAssetOfCellAtIndexPath: indexPath)
        return cell
    }
}
