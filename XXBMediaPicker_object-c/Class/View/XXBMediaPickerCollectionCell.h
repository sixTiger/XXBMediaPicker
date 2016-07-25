//
//  XXBMediaPickerCollectionCell.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBMediaAssetDataSource.h"

@interface XXBMediaPickerCollectionCell : UICollectionViewCell

@property (nonatomic, strong) id<XXBMediaAssetDataSource> mediaAsset;

@end
