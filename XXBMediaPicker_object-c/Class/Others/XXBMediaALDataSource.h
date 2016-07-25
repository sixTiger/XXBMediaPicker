//
//  XXBMediaALDataSource.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/5/27.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBMediaTableViewDataSource.h"
#import "XXBMediaCollectionDataSource.h"
#import "XXBMediaAssetDataSource.h"
#import "XXBMediaDataSource.h"

@interface XXBMediaALDataSource : NSObject<XXBMediaTableViewDataSource,XXBMediaCollectionDataSource,XXBMediaDataSource>
+ (instancetype) sharedXXBMediaALDataSource;
@end
