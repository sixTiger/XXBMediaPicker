//
//  ViewController.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "ViewController.h"
#import "XXBMediaPickerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"open" style:UIBarButtonItemStylePlain target:self action:@selector(p_choosePhotos)];
}

- (void)p_choosePhotos
{
    [self presentViewController:[XXBMediaPickerController new] animated:YES completion:nil];
}

@end
