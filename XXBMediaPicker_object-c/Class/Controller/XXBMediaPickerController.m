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

- (instancetype)init
{
    if (self = [super initWithRootViewController:[XXBMediaPickerTableViewController new]])
    {
    }
    return self;
}
@end
