//
//  XXBMediaPickerCollectionController.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerCollectionController.h"
#import "XXBMediaPickerCollectionCell.h"
#import "XXBMediaPickerVideoCollectionCell.h"
#import "XXBCollectionFootView.h"
#import "XXBImagePickerTabr.h"
#import "XXBMediaPickerConfigure.h"

@interface XXBMediaPickerCollectionController ()<UICollectionViewDataSource,UICollectionViewDelegate,XXBImagePickerTabrDelegate>

@property(nonatomic, weak) UICollectionView         *collectionView;
@property(nonatomic, weak)XXBImagePickerTabr        *imagePickerTar;
@property(nonatomic, assign) BOOL                   shouldScrollBottom;
@property(nonatomic, assign) NSInteger              selectCount;

@end


@implementation XXBMediaPickerCollectionController

static NSString *nomalCell = @"XXBMediaPickerCollectionCell";
static NSString *videoCell = @"XXBMediaPickerVideoCollectionCell";
static NSString *collectionFooter = @"XXBCollectionFootView";

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    XXBMediaPickerVideoCollectionCell *cell = (XXBMediaPickerVideoCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[[XXBMediaDataSource sharedMediaDataSouce].dataSouce numberOfRowsInCollectionViewSection:0] - 1 inSection:0]];
    if ([cell isKindOfClass:[XXBMediaPickerVideoCollectionCell class]]) {
        [cell stop];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setNeedsLayout];
    self.imagePickerTar.delegate = self;
    self.selectCount = [[XXBMediaDataSource sharedMediaDataSouce].dataSouce selectAsset].count;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.shouldScrollBottom) {
            self.shouldScrollBottom = NO;
            [self p_scrollToBottom];
            XXBMediaPickerVideoCollectionCell *cell = (XXBMediaPickerVideoCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[[XXBMediaDataSource sharedMediaDataSouce].dataSouce numberOfRowsInCollectionViewSection:0] - 1 inSection:0]];
            if ([cell isKindOfClass:[XXBMediaPickerVideoCollectionCell class]]) {
                [cell stop];
            }
        }
    });
    
}

- (void)scrollToBottom {
    if ([[XXBMediaDataSource sharedMediaDataSouce].dataSouce numberOfRowsInCollectionViewSection:0] == 0)
        return;
    self.shouldScrollBottom = YES;
}

- (void)p_scrollToBottom {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[XXBMediaDataSource sharedMediaDataSouce].dataSouce numberOfRowsInCollectionViewSection:0]- 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

#pragma mark - collectionView delegate datasouce

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[XXBMediaDataSource sharedMediaDataSouce].dataSouce numberOfSectionsInCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[XXBMediaDataSource sharedMediaDataSouce].dataSouce numberOfRowsInCollectionViewSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell ;
    id<XXBMediaAssetDataSource> mediaAsset = [[XXBMediaDataSource sharedMediaDataSouce].dataSouce mediaAssetOfIndexPath:indexPath];
    if (mediaAsset != nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:nomalCell forIndexPath:indexPath];
        [(XXBMediaPickerCollectionCell *)cell setMediaAsset:mediaAsset];
        [(XXBMediaPickerCollectionCell *)cell setEnableBage:self.mediaPickerConfigure.enableBageValue];
        [(XXBMediaPickerCollectionCell *)cell setShowCoverView:self.selectCount >= self.mediaPickerConfigure.maxSelectCount];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:videoCell forIndexPath:indexPath];
        [(XXBMediaPickerVideoCollectionCell *)cell start];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    XXBCollectionFootView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        reusableview = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionFooter forIndexPath:indexPath];
        reusableview.number = [[XXBMediaDataSource sharedMediaDataSouce].dataSouce numberOfRowsInCollectionViewSection:indexPath.section] - 1;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XXBMediaPickerCollectionCell *cell = (XXBMediaPickerCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[XXBMediaPickerCollectionCell class]]) {
        id<XXBMediaAssetDataSource> mediaAsset = [[XXBMediaDataSource sharedMediaDataSouce].dataSouce mediaAssetOfIndexPath:indexPath];
        BOOL isMediaAssetSelected = [[XXBMediaDataSource sharedMediaDataSouce].dataSouce isSelectedMediaAsset:mediaAsset];
        if ([self canSelectMedia] || isMediaAssetSelected ) {
            [[XXBMediaDataSource sharedMediaDataSouce].dataSouce didselectMediaItemAtIndexPath:indexPath];
            self.selectCount = [[XXBMediaDataSource sharedMediaDataSouce].dataSouce selectAsset].count;
        } else {
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        }
        [cell setMediaAsset:mediaAsset];
    }
    
}

#pragma mark - XXBImagePickerTabrDelegate

- (void)imagePickerTabrFinishClick {
    [self.delegate mediaPickerCollectionControllerFinishDidclick:self];
}

#pragma mark - layzLoad

- (void)setSelectCount:(NSInteger)selectCount {
    NSInteger tempCount = MAX(_selectCount, selectCount);
    _selectCount = selectCount;
    self.imagePickerTar.selectCount = selectCount;
    if (tempCount >= self.mediaPickerConfigure.maxSelectCount) {
        //更新当前cell的蒙版
        NSArray *cells = [self.collectionView visibleCells];
        BOOL showCoverView = selectCount >= self.mediaPickerConfigure.maxSelectCount;
        [cells enumerateObjectsUsingBlock:^(XXBMediaPickerCollectionCell *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[XXBMediaPickerCollectionCell class]]) {
                obj.mediaAsset = obj.mediaAsset;
                obj.showCoverView = showCoverView;
            }
        }];
    }
}

- (BOOL)enableSelect {
    return YES;
}

- (XXBImagePickerTabr *)imagePickerTar {
    if (_imagePickerTar == nil) {
        XXBImagePickerTabr *imagePickerTar = [[XXBImagePickerTabr alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [self.view insertSubview:imagePickerTar aboveSubview:self.collectionView];
        _imagePickerTar = imagePickerTar;
        
        imagePickerTar.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *imagePickerTarRight = [NSLayoutConstraint constraintWithItem:imagePickerTar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *imagePickerTarLeft = [NSLayoutConstraint constraintWithItem:imagePickerTar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *imagePickerTarBottom = [NSLayoutConstraint constraintWithItem:imagePickerTar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *imagePickerTarHeight = [NSLayoutConstraint constraintWithItem:imagePickerTar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
        [self.view addConstraints:@[imagePickerTarLeft, imagePickerTarRight,imagePickerTarBottom,imagePickerTarHeight]];
    }
    return _imagePickerTar;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat screenWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        layout.minimumInteritemSpacing = 4;
        layout.minimumLineSpacing = 4;
        CGFloat itemWidth = (screenWidth - layout.minimumInteritemSpacing)/(CGFloat)4 - layout.minimumInteritemSpacing;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.sectionInset = UIEdgeInsetsMake(layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumLineSpacing, layout.minimumInteritemSpacing);
        layout.footerReferenceSize = CGSizeMake(300.0f, 50.0f);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
        
        [collectionView registerClass:[XXBMediaPickerCollectionCell class] forCellWithReuseIdentifier:nomalCell];
        [collectionView registerClass:[XXBMediaPickerVideoCollectionCell class] forCellWithReuseIdentifier:videoCell];
        [collectionView registerClass:[XXBCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionFooter];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.alwaysBounceVertical = YES;
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *collectionViewRight = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *collectionViewLeft = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *collectionViewBottom = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-44];
        NSLayoutConstraint *collectionViewTop = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self.view addConstraints:@[collectionViewLeft, collectionViewRight,collectionViewTop,collectionViewBottom]];
    }
    return _collectionView;
}

- (BOOL)canSelectMedia {
    return  self.selectCount < self.mediaPickerConfigure.maxSelectCount;
    
}

- (void)showExcessMaxCountAlert {
//    UIAlertController *alertController = [UIAlertController ]
}
@end
