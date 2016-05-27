//
//  XXBMediaALDataSouce.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/5/27.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBMediaTableViewDataSouce.h"
#import "XXBMediaCollectionDataSouce.h"
#import "XXBMediaAssetDataSouce.h"
#import "XXBMediaDataSouce.h"

@interface XXBMediaALDataSouce : NSObject<XXBMediaTableViewDataSouce,XXBMediaCollectionDataSouce,XXBMediaDataSouce>
+ (instancetype) sharedXXBMediaALDataSouce;
@end
