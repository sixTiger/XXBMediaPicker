//
//  XXBMediaPickerCollectionDataSouce.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBMediaAssetDataSouce.h"

@protocol XXBMediaCollectionDataSouce <NSObject>
@optional
/**
 *  有多少组
 *
 *  @param mediaCollectionDataSouce 默认是0
 *
 *  @return 组数
 */
- (NSInteger) numberOfSectionsInCollectionView;

/**
 *  对应的组里边有多少数据
 *
 *  @param mediaCollectionDataSouce 实现协议的类
 *  @param section                 对应的组
 *
 *  @return 个数
 */
- (NSInteger) numberOfRowsInCollectionViewSection:(NSInteger)section;

/**
 *  对应的indexPath 的 XXBMediaAsset
 *
 *  @param indexPath
 *
 *  @return XXBMediaAsset
 */
- (id<XXBMediaAssetDataSouce>) mediaAssetOfIndexPath:(NSIndexPath *)indexPath;

@end
@interface XXBMediaCollectionDataSouce : NSObject

@end
