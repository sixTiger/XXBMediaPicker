//
//  XXBMediaPIckerTableViewController.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPIckerTableViewController.h"
#import "XXBMediaDataSouce.h"
#import "XXBMediaPickerCollectionController.h"
#import "XXBMediaPickerTableViewCell.h"

@interface XXBMediaPickerTableViewController ()<UITableViewDelegate,UITableViewDataSource,XXBMediaPickerCollectionControllerDelegate>
@property(nonatomic , weak) UITableView                             *tableView;
@property(nonatomic , strong) XXBMediaPickerCollectionController    *mediaPickerCollectionController;
@end

@implementation XXBMediaPickerTableViewController
static NSString *mediaPickerTableViewCellID = @"XXBMediaPickerTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 60;
        [self.view addSubview:tableView];
        tableView.autoresizingMask = (1 << 6) - 1;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[XXBMediaPickerTableViewCell class] forCellReuseIdentifier:mediaPickerTableViewCellID];
        [[XXBMediaDataSouce sharedMediaDataSouce].dataSouce setTableView:tableView];
        
        _tableView = tableView;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [[XXBMediaDataSouce sharedMediaDataSouce].dataSouce numberOfRowsInTableViewSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  [[XXBMediaDataSouce sharedMediaDataSouce].dataSouce numberOfSectionsInTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXBMediaPickerTableViewCell *cell = (XXBMediaPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:mediaPickerTableViewCellID];
    cell.title = [[XXBMediaDataSouce sharedMediaDataSouce].dataSouce titleOfIndex:indexPath];
    if ([[XXBMediaDataSouce sharedMediaDataSouce].dataSouce respondsToSelector:@selector(imageOfIndexPath:)]) {
        cell.placeHoderImage = [[XXBMediaDataSouce sharedMediaDataSouce].dataSouce imageOfIndexPath:indexPath];
    } else {
        cell.asset = [[XXBMediaDataSouce sharedMediaDataSouce].dataSouce mediaGroupAssetOFIndexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[XXBMediaDataSouce sharedMediaDataSouce].dataSouce didselectMediaGroupAtIndexPath:indexPath];
    [[XXBMediaDataSouce sharedMediaDataSouce].dataSouce setCollectionView:self.mediaPickerCollectionController.collectionView];
    [self.mediaPickerCollectionController.collectionView reloadData];
    [self.mediaPickerCollectionController scrollToBottom];
    [self.navigationController pushViewController:self.mediaPickerCollectionController animated:YES];
}

- (XXBMediaPickerCollectionController *)mediaPickerCollectionController {
    if (_mediaPickerCollectionController == nil) {
        _mediaPickerCollectionController = [XXBMediaPickerCollectionController new];
        _mediaPickerCollectionController.delegate = self;
    }
    return _mediaPickerCollectionController;
}

- (void)mediaPickerCollectionControllerFinishDidclick:(XXBMediaPickerCollectionController *)mediaPickerCollectionController {
    [self.delegate mediaPickerTableViewControllerFinishDidClick:self];
}
@end
