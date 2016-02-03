//
//  XXBMediaPIckerTableViewController.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPIckerTableViewController.h"
#import "XXBMediaPHDataSouce.h"

@interface XXBMediaPickerTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , weak) UITableView   *tableView;
@end

@implementation XXBMediaPickerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.rowHeight = 60;
        [self.view addSubview:tableView];
        tableView.autoresizingMask = (1 << 6) - 1;
        tableView.delegate = self;
        tableView.dataSource = self;
        [XXBMediaPHDataSouce sharedXXBMediaPHDataSouce].tableView = tableView;
        _tableView = tableView;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  [[XXBMediaPHDataSouce sharedXXBMediaPHDataSouce] numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [[XXBMediaPHDataSouce sharedXXBMediaPHDataSouce] numberOfSectionsInTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [[XXBMediaPHDataSouce sharedXXBMediaPHDataSouce] titleOfIndex:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[XXBMediaPHDataSouce sharedXXBMediaPHDataSouce] didselectMediaGroupAtIndexPath:indexPath];
}
@end
