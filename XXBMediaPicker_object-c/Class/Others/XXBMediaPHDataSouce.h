//
//  XXBMediaDataSouce.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "XXBMediaTableViewDataSouce.h"
#import "XXBMediaCollectionDataSouce.h"
#import "XXBMediaAssetDataSouce.h"

@interface XXBMediaPHDataSouce : NSObject <XXBMediaTableViewDataSouce,XXBMediaCollectionDataSouce>
+ (instancetype) sharedXXBMediaPHDataSouce;
+ (PHImageManager *) sharedImageManager;
/**
 *  当前展示数据的 tableView
 */
@property(nonatomic , weak) UITableView             *tableView;
/**
 *  当前展示数据的 collectionView
 */
@property(nonatomic , weak) UICollectionView        *collectionView;

/**
 *  选中的对应的分组
 *
 *  @param indexParh
 */
- (void)didselectMediaGroupAtIndexPath:(NSIndexPath *)indexPath;


/**
 *  选中的对应的分组
 *
 *  @param indexPath
 */
- (void)didselectMediaItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)indexOfAssetInSelectedMediaAsset:(id<XXBMediaAssetDataSouce>)mediaAsset;
@end
