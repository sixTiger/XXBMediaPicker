//
//  XXBMediaPickerViewController.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerController.h"
#import "XXBMediaPickerTableViewController.h"
#import "XXBMediaDataSource.h"
#import "XXBMediaPickerConfigure.h"


@interface XXBMediaPickerController ()<XXBMediaPickerTableViewControllerDelegate>

@property(nonatomic ,strong) XXBMediaPickerTableViewController  *mediaPickerTableViewController;
@property(nonatomic, strong) XXBMediaPickerConfigure            *mediaPickerConfigure;

@end

@implementation XXBMediaPickerController

@dynamic delegate;

/**
 初始化媒体选择器
 
 @return 初始化好的媒体选择器
 */
+ (XXBMediaPickerController *)mediaPickerController {
    XXBMediaPickerConfigure *mediaPickerConfigure = [[XXBMediaPickerConfigure alloc] init];
    return [self mediaPickerControllerWithConfigure:mediaPickerConfigure];
}

/**
 初始化媒体选择器
 
 @param mediaPickerConfigure 媒体选择器的配置
 @return 初始化好的媒体选择器
 */
+ (XXBMediaPickerController *)mediaPickerControllerWithConfigure:(XXBMediaPickerConfigure *)mediaPickerConfigure {
    XXBMediaPickerController *mediaPickerController = [[XXBMediaPickerController alloc] initWithConfigure:mediaPickerConfigure];
    return mediaPickerController;
}

- (instancetype)initWithConfigure:(XXBMediaPickerConfigure *)mediaPickerConfigure {
    if (self = [super initWithRootViewController:self.mediaPickerTableViewController]) {
        self.mediaPickerConfigure = mediaPickerConfigure;
    }
    return self;
}

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

- (void)setMediaPickerConfigure:(XXBMediaPickerConfigure *)mediaPickerConfigure {
    _mediaPickerConfigure = mediaPickerConfigure;
    self.mediaPickerTableViewController.mediaPickerConfigure = mediaPickerConfigure;
}

#pragma mark - XXBMediaPickerTableViewControllerDelegate
- (void)mediaPickerTableViewControllerFinishDidClick:(XXBMediaPickerTableViewController *)mediaPickerTableViewController {
    if ([self.delegate respondsToSelector:@selector(mediaPickerControllerFinishDidClick:andSlectedMedias:)]) {
        [self.delegate mediaPickerControllerFinishDidClick:self andSlectedMedias: [[XXBMediaDataSource sharedMediaDataSouce].dataSouce selectAsset]];
    }
}
@end
