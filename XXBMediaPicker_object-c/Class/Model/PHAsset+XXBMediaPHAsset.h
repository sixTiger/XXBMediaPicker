//
//  NSObject+XXBMediaPHAsset.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/4.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBMediaAssetDataSource.h"
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>


@interface PHAsset (XXBMediaPHAsset)<XXBMediaAssetDataSource>
@property(nonatomic , strong , readonly) UIImage   *placehoderImage;
@end
