//
//  XXBMediaTableViewDataSouce.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBMediaAssetDataSouce.h"


@protocol XXBMediaTableViewDataSouce <NSObject>

@optional
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

/**
 *  返回对应的分组的第一个图片资源
 *
 *  @return 第一个图片资源
 */
- (id <XXBMediaAssetDataSouce>)imageOfIndex:(NSIndexPath *)indexPath;

@end

@interface XXBMediaTableViewDataSouce : NSObject

@end
