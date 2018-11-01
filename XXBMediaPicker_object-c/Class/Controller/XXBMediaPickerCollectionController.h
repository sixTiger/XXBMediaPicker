//
//  XXBMediaPickerCollectionController.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXBMediaPickerCollectionController, XXBMediaPickerConfigure;

@protocol XXBMediaPickerCollectionControllerDelegate <NSObject>

- (void)mediaPickerCollectionControllerFinishDidclick:(XXBMediaPickerCollectionController *)mediaPickerCollectionController;

@end

@interface XXBMediaPickerCollectionController : UIViewController

@property(nonatomic ,weak) id<XXBMediaPickerCollectionControllerDelegate>   delegate;

@property(nonatomic, strong) XXBMediaPickerConfigure                        *mediaPickerConfigure;

- (void)scrollToBottom;

- (void)reload;
@end
