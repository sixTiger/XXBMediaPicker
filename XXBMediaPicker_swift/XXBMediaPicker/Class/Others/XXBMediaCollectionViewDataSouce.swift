//
//  XXBMediaCollectionViewDataSouce.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/14.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

public protocol XXBMediaCollectionViewDataSouce : NSObjectProtocol {
    @available(iOS 2.0, *)
    func mediaCollectionViewDataSouce(collectionView: UICollectionView , numberOfRowsInSection section: Int) -> Int
    
    @available(iOS 2.0, *)
    func mediaCollectionViewDataSouceNumberOfSection(collectionView: UICollectionView) -> Int
    
    @available(iOS 2.0, *)
    func mediaCollectionViewDataSouce(collectionView: UICollectionView , typeOfMediaAtIndexPath indexPath: NSIndexPath) -> XXBMediaType

    @available(iOS 2.0, *)
    func mediaCollectionViewDataSouce(collectionView: UICollectionView , mediaAssetOfCellAtIndexPath indexPath: NSIndexPath) -> XXBMediaAssetDataSouce?
    
    @available(iOS 2.0, *)
    func mediaCollectionViewDataSouce(collectionView: UICollectionView , didSelectCellAtIndexPath indexPath: NSIndexPath)
}
