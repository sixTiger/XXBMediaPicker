//
//  XXBMediaPIckerTableViewController.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerTableViewController.h"
#import "XXBMediaDataSource.h"
#import "XXBMediaPickerCollectionController.h"
#import "XXBMediaPickerTableViewCell.h"
#import "XXBMediaLoadingView.h"
#import "XXBMediaDataSource.h"
#import "XXBMediaConsts.h"

@interface XXBMediaPickerTableViewController ()<UITableViewDelegate,UITableViewDataSource,XXBMediaPickerCollectionControllerDelegate>

@property(nonatomic , weak) UITableView                             *tableView;

@property(nonatomic , strong) XXBMediaPickerCollectionController    *mediaPickerCollectionController;

@property(nonatomic, weak) XXBMediaLoadingView                      *loadingView;
@end

@implementation XXBMediaPickerTableViewController
static NSString *mediaPickerTableViewCellID = @"XXBMediaPickerTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self.tableView reloadData];
    [self showMediaPickerCollectionControlleAnimated:NO];
    if ([[XXBMediaDataSource sharedMediaDataSouce].dataSouce isLoadingSectionsData]) {
        [self.loadingView startAnimating];
    }
}

- (void)dealloc {
    [self removeNotification];
}

- (void)showMediaPickerCollectionControlleAnimated:(BOOL)animated {
    [self.mediaPickerCollectionController scrollToBottom];
    [self.mediaPickerCollectionController reload];
    [self.navigationController pushViewController:self.mediaPickerCollectionController animated:animated];
}
#pragma mark - layzload

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
        [[XXBMediaDataSource sharedMediaDataSouce].dataSouce setTableView:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (XXBMediaLoadingView *)loadingView {
    if (_loadingView == nil) {
        XXBMediaLoadingView *loadingView = [[XXBMediaLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:loadingView];
        _loadingView = loadingView;
    }
    return _loadingView;
}

- (void)setMediaPickerConfigure:(XXBMediaPickerConfigure *)mediaPickerConfigure {
    _mediaPickerConfigure = mediaPickerConfigure;
    self.mediaPickerCollectionController.mediaPickerConfigure = mediaPickerConfigure;
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [[XXBMediaDataSource sharedMediaDataSouce].dataSouce numberOfRowsInTableViewSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  [[XXBMediaDataSource sharedMediaDataSouce].dataSouce numberOfSectionsInTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXBMediaPickerTableViewCell *cell = (XXBMediaPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:mediaPickerTableViewCellID];
    cell.title = [[XXBMediaDataSource sharedMediaDataSouce].dataSouce titleOfIndex:indexPath];
    if ([[XXBMediaDataSource sharedMediaDataSouce].dataSouce respondsToSelector:@selector(imageOfIndexPath:)]) {
        cell.placeHoderImage = [[XXBMediaDataSource sharedMediaDataSouce].dataSouce imageOfIndexPath:indexPath];
    } else {
        cell.asset = [[XXBMediaDataSource sharedMediaDataSouce].dataSouce mediaGroupAssetOFIndexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[XXBMediaDataSource sharedMediaDataSouce].dataSouce didselectMediaGroupAtIndexPath:indexPath];
    [self showMediaPickerCollectionControlleAnimated:YES];
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

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaSectionsDataCompletion:) name:kXXBMediaSectionsDataCompletion object:nil];
}

- (void)mediaSectionsDataCompletion:(NSNotification *)notification {
    [[self tableView] reloadData];
    [self.loadingView stopAnimating];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
