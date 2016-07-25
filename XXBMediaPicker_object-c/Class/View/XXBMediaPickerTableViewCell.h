//
//  XXBMediaPickerTableViewCell.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBMediaAssetDataSource.h"

@interface XXBMediaPickerTableViewCell : UITableViewCell

@property(nonatomic , copy) NSString                        *title;
@property(nonatomic , strong) id<XXBMediaAssetDataSource>    asset;
/**
 *  ALAset可以直接拿到头图
 */
@property(nonatomic , strong) UIImage                       *placeHoderImage;
@end
