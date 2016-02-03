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

@interface XXBMediaPHDataSouce : NSObject <XXBMediaTableViewDataSouce,XXBMediaCollectionDataSouce>
+ (instancetype)sharedXXBMediaPHDataSouce;
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
- (void)didselectMediaGroupAtIndexPath:(NSIndexPath *)indexParh;
@end
