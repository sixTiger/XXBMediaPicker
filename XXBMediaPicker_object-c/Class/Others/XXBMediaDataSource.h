//
//  XXBMediaDataSource.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBMediaAssetDataSource.h"
#import "XXBMediaTableViewDataSource.h"
#import "XXBMediaCollectionDataSource.h"
#import "XXBMediaAssetDataSource.h"

@protocol XXBMediaDataSource <NSObject>

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
- (NSUInteger)indexOfAssetInSelectedMediaAsset:(id<XXBMediaAssetDataSource>)mediaAsset;

/**
 当前资源是否是选中的

 @param mediaAsset 资源
 @return 是否选中
 */
- (BOOL)isSelectedMediaAsset:(id<XXBMediaAssetDataSource>)mediaAsset;

/**
 *  当前选中的媒体资源
 *
 *  @return 当前选中的媒体资源数组
 */
- (NSArray *)selectAsset;

@end

@interface XXBMediaDataSource : NSObject

+ (instancetype ) sharedMediaDataSouce;

@property(nonatomic , strong) id<XXBMediaDataSource,XXBMediaTableViewDataSource,XXBMediaCollectionDataSource> dataSouce;
@end
