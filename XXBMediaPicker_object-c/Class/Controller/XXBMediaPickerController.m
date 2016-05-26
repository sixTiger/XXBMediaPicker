//
//  XXBMediaPickerViewController.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerController.h"
#import "XXBMediaTableViewDataSouce.h"
#import "XXBMediaPickerTableViewController.h"

@implementation XXBMediaPickerController

- (instancetype)init {
    if (self = [super initWithRootViewController:[XXBMediaPickerTableViewController new]]) {
    }
    return self;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *popPre = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(p_cancaleClick)];
    viewController.navigationItem.rightBarButtonItem = popPre;
    [super pushViewController:viewController animated:animated];
}

- (void)p_cancaleClick {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
