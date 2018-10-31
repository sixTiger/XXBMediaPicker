//
//  XXBMediaPickerViewController.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXBMediaPickerController, XXBMediaPickerConfigure;

@protocol XXBMediaPickerControllerDelegate <UINavigationControllerDelegate>

@optional

- (void)mediaPickerControllerCancleDidClick:(XXBMediaPickerController *)mediaPickerController;

@required

- (void)mediaPickerControllerFinishDidClick:(XXBMediaPickerController *)mediaPickerController andSlectedMedias:(NSArray *)selectMediaArray;

@end

@interface XXBMediaPickerController : UINavigationController


/**
 初始化媒体选择器

 @return 初始化好的媒体选择器
 */
+ (XXBMediaPickerController *)mediaPickerController;

/**
 初始化媒体选择器

 @param mediaPickerConfigure 媒体选择器的配置
 @return 初始化好的媒体选择器
 */
+ (XXBMediaPickerController *)mediaPickerControllerWithConfigure:(XXBMediaPickerConfigure *)mediaPickerConfigure;

/**
 *  是否展示左上角标
 */
@property(nonatomic , assign) BOOL   showBadgeValue;

@property(nonatomic ,weak) id<XXBMediaPickerControllerDelegate> delegate;
@end
