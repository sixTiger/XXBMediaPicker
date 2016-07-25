//
//  XXBMediaDataSource.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "XXBMediaTableViewDataSource.h"
#import "XXBMediaCollectionDataSource.h"
#import "XXBMediaAssetDataSource.h"
#import "XXBMediaDataSource.h"

@interface XXBMediaPHDataSource : NSObject <XXBMediaTableViewDataSource,XXBMediaCollectionDataSource,XXBMediaDataSource>
+ (instancetype) sharedXXBMediaPHDataSource;
+ (PHImageManager *) sharedImageManager;
@end
