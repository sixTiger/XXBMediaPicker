//
//  XXBDataDouce.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/2.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit

import Photos

public class XXBDataSouce: NSObject ,XXBMediaTableViewDataSouce{
    
    static let sharedInstance = XXBDataSouce()
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
    } //This prevents others from using the default '()' initializer for this class.
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
    
    //MARK: photoData
    
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
        
        for category in allValues{
            //Do something
            let smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: category, options: nil)
            let collection = smartAlbums.firstObject
            if ((collection as? PHAssetCollection) == nil) {
                continue
            }
            print(collection!.localizedTitle)
            let assetsFetchResult = PHAsset.fetchAssetsInAssetCollection(collection as! PHAssetCollection , options: nil)
            if assetsFetchResult.count < 0 {
            }
            //判空操作
            sectionFetchResults.append(smartAlbums)
            //
            //        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
            //        [self.sectionFetchResults addObject:topLevelUserCollections];
        }
        
    }
    //MARK: -
    //MARK: -
}
