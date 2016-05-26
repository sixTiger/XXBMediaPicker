//
//  XXBMediaDataSouce.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBMediaAssetDataSouce.h"
#import "XXBMediaTableViewDataSouce.h"
#import "XXBMediaCollectionDataSouce.h"
#import "XXBMediaAssetDataSouce.h"

@protocol XXBMediaDataSouce <NSObject>

/**
 *  设置 collectionView
 */
- (void)setCollectionView:(UICollectionView *)collectionView;

/**
 *  数据元对应的 tableView
 */
- (void)setTableView:(UITableView *)tableView;

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

/**
 *  mediaAsset 在选中的数组中的下表
 */
- (NSUInteger)indexOfAssetInSelectedMediaAsset:(id<XXBMediaAssetDataSouce>)mediaAsset;

/**
 *  当前选中的媒体资源
 *
 *  @return 当前选中的媒体资源数组
 */
- (NSArray *)selectAsset;

@end

@interface XXBMediaDataSouce : NSObject

+ (instancetype ) sharedMediaDataSouce;

@property(nonatomic , strong) id<XXBMediaDataSouce,XXBMediaTableViewDataSouce,XXBMediaCollectionDataSouce> dataSouce;
@end
