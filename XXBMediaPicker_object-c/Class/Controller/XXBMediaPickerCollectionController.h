//
//  XXBMediaPickerCollectionController.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXBMediaPickerCollectionController : UIViewController

@property(nonatomic , weak , readonly) UICollectionView        *collectionView;

- (void)scrollToButtom;
@end
