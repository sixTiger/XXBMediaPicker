//
//  XXBMediaPickerViewController.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXBMediaPickerController;

@protocol XXBMediaPickerControllerDelegate <UINavigationControllerDelegate>

@optional

- (void)mediaPickerControllerCancleDidClick:(XXBMediaPickerController *)mediaPickerController;

@required

- (void)mediaPickerControllerFinishDidClick:(XXBMediaPickerController *)mediaPickerController andSlectedMedias:(NSArray *)selectMediaArray;

@end

@interface XXBMediaPickerController : UINavigationController

/**
 *  是否展示左上角标
 */
@property(nonatomic , assign) BOOL   showBadgeValue;

@property(nonatomic ,weak) id<XXBMediaPickerControllerDelegate> delegate;
@end
