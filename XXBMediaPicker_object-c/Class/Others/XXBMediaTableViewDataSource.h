//
//  XXBMediaTableViewDataSource.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBMediaAssetDataSource.h"


@protocol XXBMediaTableViewDataSource <NSObject>
@required

/**
 *  有多少组
 *
 *  @param mediaTableViewDataSouce 默认是0
 *
 *  @return 组数
 */
- (NSInteger)numberOfSectionsInTableView;

/**
 *  对应的组里边有多少数据
 *
 *  @param mediaTableViewDataSouce 实现协议的类
 *  @param section                 对应的组
 *
 *  @return 个数
 */
- (NSInteger)numberOfRowsInTableViewSection:(NSInteger)section;

/**
 *  返回对应的标题
 *
 *  @return 标题
 */
- (NSString *)titleOfIndex:(NSIndexPath *)indexPath;

@optional

/**
 *  返回对应的分组的第一个图片资源
 *
 *  @return 第一个图片资源
 */
- (id <XXBMediaAssetDataSource>)mediaGroupAssetOFIndexPath:(NSIndexPath *)indexPath;

/**
 *  返回indexPath相册分组的封面图片
 *
 *  @param indexPath 当前的indexPath
 *
 *  @return 封面图片
 */
- (UIImage *)imageOfIndexPath:(NSIndexPath *)indexPath;

@end

