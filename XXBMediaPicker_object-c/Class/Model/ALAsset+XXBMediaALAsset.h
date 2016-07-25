//
//  ALAsset+XXBMediaALAsset.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/5/27.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBMediaAssetDataSource.h"
@import AssetsLibrary;

@interface ALAsset (XXBMediaPHAsset)<XXBMediaAssetDataSource>

@property(nonatomic , strong , readonly) UIImage   *placehoderImage;
@end
