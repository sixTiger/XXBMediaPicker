//
//  XXBDataDouce.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/2.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

import Photos

public class XXBDataSouce: NSObject, XXBMediaTableViewDataSouce, XXBMediaCollectionViewDataSouce, PHPhotoLibraryChangeObserver{
    
    static let sharedInstance = XXBDataSouce()
    static let sharedImageManager: PHImageManager = PHCachingImageManager()
    var tableView: UITableView?
    var collectionView: UICollectionView?
    var seleectPHFetchResult: PHFetchResult?
    
    lazy var  sectionFetchResults: [PHFetchResult] = {
        return [PHFetchResult]()
    }()
    
    lazy var  selectAssetArray: [XXBMediaAssetDataSouce] = {
        return [XXBMediaAssetDataSouce]()
    }()
    
    
    private override init() {
        super.init()
        getAllPhotos()
        registerPhotoServers()
    } //This prevents others from using the default '()' initializer for this class.
    
    deinit {
        removerPhotoServers()
    }
    
    //MARK:- tableView数据源方法
    public func mediaTableViewDataSouceNumberOfSection(tableView:UITableView) -> Int {
        return sectionFetchResults.count;
    }
    
    public func mediaTableViewDataSouce(tableView:UITableView,numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        
        if (section == 0) {
            numberOfRows = 1;
        } else {
            let fetchResult = self.sectionFetchResults[section];
            numberOfRows = fetchResult.count;
        }
        return numberOfRows;
    }
    
    public func mediaTableViewDataSouce(tableView: UITableView, titleOfCellAtIndexPath indexPath: NSIndexPath) -> String {
        if indexPath.section == 0 {
            return  "全部照片";
        } else {
            let fetchResult = sectionFetchResults[indexPath.section]
            let collection = fetchResult[indexPath.row];
            if ((collection as? PHAssetCollection) == nil) {
                return "无效相册"
            } else {
                return  collection.localizedTitle;
            }
        }
    }
    
    public func mediaTableViewDataSouce(tableView: UITableView, mediaAssetOfCellAtIndexPath indexPath: NSIndexPath) -> XXBMediaAssetDataSouce? {
        
        if(indexPath.section >= self.sectionFetchResults.count) {
            return nil
        }
        let fetchResult = sectionFetchResults[indexPath.section]
        
        if indexPath.section == 0 {
            return fetchResult.firstObject as? XXBMediaAssetDataSouce
        } else {
            let collection = fetchResult[indexPath.row]
            if ((collection as? PHAssetCollection) == nil) {
                return nil;
            }
            let assetsFetchResult = PHAsset.fetchAssetsInAssetCollection(collection as! PHAssetCollection, options: nil)
            return assetsFetchResult.firstObject as? XXBMediaAssetDataSouce
        }
    }
    
    public func mediaTableViewDataSouce(tableView: UITableView, didSelectCellAtIndexPath indexPath: NSIndexPath) {
        
        let fetchResult = sectionFetchResults[indexPath.section]
        if (indexPath.section == 0) {
            seleectPHFetchResult = fetchResult;
        } else {
            let collection = fetchResult[indexPath.row] as! PHCollection
            if ((collection as? PHAssetCollection) == nil) {
                return;
            }
            let assetsFetchResult = PHAsset.fetchAssetsInAssetCollection(collection as! PHAssetCollection, options: nil)
            seleectPHFetchResult = assetsFetchResult;
        }
        collectionView?.reloadData()
    }
    
    //MARK:- collectionView 数据源方法
    
    public func mediaCollectionViewDataSouceNumberOfSection(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func mediaCollectionViewDataSouce(collectionView: UICollectionView, numberOfRowsInSection section: Int) -> Int {
        return seleectPHFetchResult!.count
    }
    
    public func mediaCollectionViewDataSouce(collectionView: UICollectionView, mediaAssetOfCellAtIndexPath indexPath: NSIndexPath) -> XXBMediaAssetDataSouce? {
        if (indexPath.row < seleectPHFetchResult!.count) {
            return seleectPHFetchResult![indexPath.row] as? XXBMediaAssetDataSouce;
        } else {
            return nil;
        }
    }
    
    public func mediaCollectionViewDataSouce(collectionView: UICollectionView, typeOfMediaAtIndexPath indexPath: NSIndexPath) -> XXBMediaType {
        return XXBMediaType.Unknown
    }
    
    public func mediaCollectionViewDataSouce(collectionView: UICollectionView, didSelectCellAtIndexPath indexPath: NSIndexPath) {
    }
    
    //MARK:- photoData
    
    func getAllPhotos () {
        sectionFetchResults.removeAll()
        let allphotoOptions: PHFetchOptions = PHFetchOptions()
        allphotoOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        //全部照片
        let allPhotos: PHFetchResult = PHAsset.fetchAssetsWithOptions(allphotoOptions)
        sectionFetchResults.append(allPhotos)
        //其他的分类
        var allValues: [PHAssetCollectionSubtype]
        if #available(iOS 9.0, *) {
            allValues = [
                PHAssetCollectionSubtype.SmartAlbumGeneric,
                PHAssetCollectionSubtype.SmartAlbumPanoramas,
                PHAssetCollectionSubtype.SmartAlbumVideos,
                PHAssetCollectionSubtype.SmartAlbumFavorites,
                PHAssetCollectionSubtype.SmartAlbumTimelapses,
                PHAssetCollectionSubtype.SmartAlbumAllHidden,
                PHAssetCollectionSubtype.SmartAlbumRecentlyAdded,
                PHAssetCollectionSubtype.SmartAlbumBursts,
                PHAssetCollectionSubtype.SmartAlbumSlomoVideos,
                PHAssetCollectionSubtype.SmartAlbumUserLibrary,
                PHAssetCollectionSubtype.SmartAlbumSelfPortraits,
                PHAssetCollectionSubtype.SmartAlbumScreenshots
            ]
        } else {
            allValues = [
                PHAssetCollectionSubtype.SmartAlbumGeneric,
                PHAssetCollectionSubtype.SmartAlbumPanoramas,
                PHAssetCollectionSubtype.SmartAlbumVideos,
                PHAssetCollectionSubtype.SmartAlbumFavorites,
                PHAssetCollectionSubtype.SmartAlbumTimelapses,
                PHAssetCollectionSubtype.SmartAlbumAllHidden,
                PHAssetCollectionSubtype.SmartAlbumRecentlyAdded,
                PHAssetCollectionSubtype.SmartAlbumBursts,
                PHAssetCollectionSubtype.SmartAlbumSlomoVideos,
                PHAssetCollectionSubtype.SmartAlbumUserLibrary
            ]
        }
        
        for category in allValues {
            //Do something
            let smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: category, options: nil)
            let collection = smartAlbums.firstObject
            if ((collection as? PHAssetCollection) == nil) {
                continue
            }
            
            let assetsFetchResult = PHAsset.fetchAssetsInAssetCollection(collection as! PHAssetCollection , options: nil)
            if assetsFetchResult.count < 0 {
            }
            //判空操作
            sectionFetchResults.append(smartAlbums)
            //
            //        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
            //        [self.sectionFetchResults addObject:topLevelUserCollections];
        }
        // 用户自己创建的相册
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        sectionFetchResults.append(topLevelUserCollections)
        
    }
    //MARK: -
    //MARK: 相册信息发生变化的时候
    func registerPhotoServers() {
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }
    
    func removerPhotoServers() {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    public func photoLibraryDidChange(changeInstance: PHChange) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            /**
             *  看一下当前的是否有新创建的相册
             */
            
            var  reloadRequired = false;
            for (index, collectionsFetchResult) in self.sectionFetchResults.enumerate() {
                
                let changeDetails = changeInstance.changeDetailsForFetchResult(collectionsFetchResult)
                if (changeDetails != nil) {
                    self.sectionFetchResults[index] = (changeDetails?.fetchResultAfterChanges)!
                    reloadRequired = true
                }
            }
            
            if (reloadRequired)
            {
                self.tableView?.reloadData()
            }
            
            let collectionChanges = changeInstance.changeDetailsForFetchResult(self.seleectPHFetchResult!)
            if (collectionChanges == nil) {
                /**
                *  当前选中的
                */
                return;
            }
            
            if !(collectionChanges!.hasIncrementalChanges) || (collectionChanges!.hasMoves)  {
                //相册被移除
            } else {
//                self.collectionView?.performBatchUpdates({ () -> Void in
                
                    let removedIndexes = collectionChanges?.removedIndexes
                    if removedIndexes?.count > 0 {
                        let removeIndexPaths = removedIndexes!.XXB_indexPathsFromIndexesWithSection(0)
                        self.collectionView?.deleteItemsAtIndexPaths(removeIndexPaths)
                    }
                    
                    let insertedIndexes = collectionChanges?.insertedIndexes
                    if insertedIndexes?.count > 0 {
                        
                        let insertedIndexPaths = insertedIndexes!.XXB_indexPathsFromIndexesWithSection(0)
                        self.collectionView?.insertItemsAtIndexPaths(insertedIndexPaths)
                    }
                    
                    let changedIndexes = collectionChanges?.changedIndexes
                    if changedIndexes?.count > 0 {
                        
                        let changedIndexPaths = changedIndexes!.XXB_indexPathsFromIndexesWithSection(0)
                        self.collectionView?.reloadItemsAtIndexPaths(changedIndexPaths)
                    }
                    
//                    }, completion:nil)
            }
            
            //FIXME: 相册被删除的时候应该考虑一下被选中的同样应该被移除
            
        }
        
    }
    
    //MARK: -
}
