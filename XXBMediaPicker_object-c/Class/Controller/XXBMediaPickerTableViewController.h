//
//  XXBMediaPIckerTableViewController.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXBMediaPickerTableViewController, XXBMediaPickerConfigure;

@protocol XXBMediaPickerTableViewControllerDelegate <NSObject>

- (void)mediaPickerTableViewControllerFinishDidClick:(XXBMediaPickerTableViewController *)mediaPickerTableViewController;

@end

@interface XXBMediaPickerTableViewController : UIViewController

@property(nonatomic ,weak) id<XXBMediaPickerTableViewControllerDelegate>    delegate;

@property(nonatomic, strong) XXBMediaPickerConfigure                        *mediaPickerConfigure;
@end
