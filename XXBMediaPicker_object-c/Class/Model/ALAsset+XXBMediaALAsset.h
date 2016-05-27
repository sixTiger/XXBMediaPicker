//
//  ALAsset+XXBMediaALAsset.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/5/27.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBMediaAssetDataSouce.h"
@import AssetsLibrary;

@interface ALAsset (XXBMediaPHAsset)<XXBMediaAssetDataSouce>

@property(nonatomic , strong , readonly) UIImage   *placehoderImage;
@end
