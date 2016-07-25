//
//  XXBMediaPickerViewController.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerController.h"
#import "XXBMediaPickerTableViewController.h"
#import "XXBMediaDataSouce.h"


@interface XXBMediaPickerController ()<XXBMediaPickerTableViewControllerDelegate>

@property(nonatomic ,strong) XXBMediaPickerTableViewController *mediaPickerTableViewController;
@end

@implementation XXBMediaPickerController

@dynamic delegate;

- (instancetype)init {
    if (self = [super initWithRootViewController:self.mediaPickerTableViewController]) {
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
    __weak typeof(self) weakSlelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(weakSlelf) strongSelf = weakSlelf;
        if ([strongSelf.delegate respondsToSelector:@selector(mediaPickerControllerCancleDidClick:)]) {
            [strongSelf.delegate mediaPickerControllerCancleDidClick:self];
        }
    }];
}

#pragma mark - layz load

- (XXBMediaPickerTableViewController *)mediaPickerTableViewController {
    if (_mediaPickerTableViewController == nil) {
        _mediaPickerTableViewController = [[XXBMediaPickerTableViewController alloc] init];
        _mediaPickerTableViewController.delegate = self;
    }
    return _mediaPickerTableViewController;
}
- (void)mediaPickerTableViewControllerFinishDidClick:(XXBMediaPickerTableViewController *)mediaPickerTableViewController {
//    XXBMediaDataSouce *mediaDataSouce
}
@end
