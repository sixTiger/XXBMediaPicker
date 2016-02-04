//
//  XXBMediaPickerCollectionController.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerCollectionController.h"
#import "XXBMediaPickerCollectionCell.h"
#import "XXBMediaPHDataSouce.h"
#import "XXBMediaPickerVideoCollectionCell.h"

@interface XXBMediaPickerCollectionController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic , weak) UICollectionView        *collectionView;

@end


@implementation XXBMediaPickerCollectionController

static NSString *nomalCell = @"XXBMediaPickerCollectionCell";
static NSString *videoCell = @"XXBMediaPickerVideoCollectionCell";

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    XXBMediaPickerVideoCollectionCell *cell = (XXBMediaPickerVideoCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if ([cell isKindOfClass:[XXBMediaPickerVideoCollectionCell class]])
    {
        [cell stop];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    XXBMediaPickerVideoCollectionCell *cell = (XXBMediaPickerVideoCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if ([cell isKindOfClass:[XXBMediaPickerVideoCollectionCell class]])
    {
        [cell start];
    }
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat screenWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        layout.minimumInteritemSpacing = 4;
        layout.minimumLineSpacing = 4;
        CGFloat itemWidth = (screenWidth - layout.minimumInteritemSpacing)/(CGFloat)4 - layout.minimumInteritemSpacing;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.sectionInset = UIEdgeInsetsMake(layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumLineSpacing, layout.minimumInteritemSpacing);
        layout.footerReferenceSize = CGSizeMake(300.0f, 50.0f);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [self.view addSubview:collectionView];
        collectionView.autoresizingMask = (1 << 6) - 1;
        [collectionView registerClass:[XXBMediaPickerCollectionCell class] forCellWithReuseIdentifier:nomalCell];
        [collectionView registerClass:[XXBMediaPickerVideoCollectionCell class] forCellWithReuseIdentifier:videoCell];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[XXBMediaPHDataSouce sharedXXBMediaPHDataSouce] numberOfSectionsInCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[XXBMediaPHDataSouce sharedXXBMediaPHDataSouce] numberOfRowsInCollectionViewSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell ;
    id<XXBMediaAssetDataSouce> mediaAsset = [[XXBMediaPHDataSouce sharedXXBMediaPHDataSouce] mediaAssetOfIndexPath:indexPath];
    if (mediaAsset == nil)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:videoCell forIndexPath:indexPath];
        [(XXBMediaPickerVideoCollectionCell *)cell start];
        
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:nomalCell forIndexPath:indexPath];
        [(XXBMediaPickerCollectionCell *)cell setMediaAsset:mediaAsset];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [[XXBMediaPHDataSouce sharedXXBMediaPHDataSouce] didselectMediaItemAtIndexPath:indexPath];
    XXBMediaPickerCollectionCell * cell = (XXBMediaPickerCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = !cell.selected;
}
@end
