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
#import "XXBMediaDataSouce.h"

@interface XXBMediaPHDataSouce : NSObject <XXBMediaTableViewDataSouce,XXBMediaCollectionDataSouce,XXBMediaDataSouce>
+ (instancetype) sharedXXBMediaPHDataSouce;
+ (PHImageManager *) sharedImageManager;
@end
