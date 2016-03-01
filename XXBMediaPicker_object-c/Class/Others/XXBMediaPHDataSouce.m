//
//  XXBMediaDataSouce.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPHDataSouce.h"
#import "NSIndexSet+Convenience.h"
#import "PHAsset+XXBMediaPHAsset.h"

@interface XXBMediaPHDataSouce ()<PHPhotoLibraryChangeObserver>
/**
 *  当前展示数据的 tableView
 */
@property(nonatomic , weak) UITableView             *tableView;
/**
 *  当前展示数据的 collectionView
 */
@property(nonatomic , weak) UICollectionView        *collectionView;
@property(nonatomic , strong) NSMutableArray    *sectionFetchResults;
@property(nonatomic , strong) PHFetchResult     *seleectPHFetchResult;
@property(nonatomic , strong) NSMutableArray    *selectAssetArray;
@end

@implementation XXBMediaPHDataSouce

static id _instance = nil;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (_instance == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

+ (instancetype)sharedXXBMediaPHDataSouce
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super alloc] init];
    });
    return _instance;
}


+ (PHImageManager *) sharedImageManager
{
    static id _sharedImageManager = nil;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedImageManager = [[PHCachingImageManager alloc] init];
    });
    return _sharedImageManager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self p_getAllPhotos];
        [self p_registerPhotoServers];
    }
    return self;
}

/**
 *  注册相册服务
 */
- (void)p_registerPhotoServers
{
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)p_getAllPhotos
{
    [self.sectionFetchResults removeAllObjects];
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    [self.sectionFetchResults addObject:allPhotos];
    for (PHAssetCollectionSubtype i = 201; i < 212; i++)
    {
        if (i == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded || i == PHAssetCollectionSubtypeSmartAlbumUserLibrary)
        {
            // 最近添加的忽略 相机交卷忽略
            continue;
        }
        
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:i options:nil];
        PHCollection *collection = [smartAlbums firstObject];
        if (![collection isKindOfClass:[PHAssetCollection class]])
        {
            return;
        }
        // Configure the AAPLAssetGridViewController with the asset collection.
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        if (assetsFetchResult.count > 0)
        {
            [self.sectionFetchResults addObject:smartAlbums];
        }
    }
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [self.sectionFetchResults addObject:topLevelUserCollections];
    
}
- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [self p_getAllPhotos];
//        NSLog(@"%@",self.sectionFetchResults);
        /**
         *  看一下当前的是否有新创建的相册
         */
        // Loop through the section fetch results, replacing any fetch results that have been updated.
        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        __block BOOL reloadRequired = NO;
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            
            if (changeDetails != nil)
            {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        
        if (reloadRequired)
        {
            self.sectionFetchResults = updatedSectionFetchResults;
            [self.tableView reloadData];
        }
        
        
        
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.seleectPHFetchResult];
        if (collectionChanges == nil)
        {
            /**
             *  当前选中的
             */
            return;
        }
        
        /*
         Change notifications may be made on a background queue. Re-dispatch to the
         main queue before acting on the change as we'll be updating the UI.
         */
        // Get the new fetch result.
        self.seleectPHFetchResult = [collectionChanges fetchResultAfterChanges];
        //        [self.collectionView reloadData];
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves])
        {
            // Reload the collection view if the incremental diffs are not available
            // 相册被移除
            
        }
        else
        {
            /*
             Tell the collection view to animate insertions and deletions if we
             have incremental diffs.
             */
            [self.collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [self.collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [self.collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [self.collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
            } completion:NULL];
        }
        
    });
    
}




- (NSUInteger)indexOfAssetInSelectedMediaAsset:(id<XXBMediaAssetDataSouce>)mediaAsset
{
    NSUInteger position = [self.selectAssetArray indexOfObjectPassingTest:^BOOL(id<XXBMediaAssetDataSouce> loopAsset, NSUInteger idx, BOOL *stop) {
        return   [[mediaAsset identifier]  isEqual:[loopAsset identifier]];
    }];
    return position;
}

#pragma mark - layzeload

- (NSMutableArray *)sectionFetchResults
{
    if (_sectionFetchResults == nil)
    {
        _sectionFetchResults = [NSMutableArray array];
    }
    return _sectionFetchResults;
}

- (NSMutableArray *)selectAssetArray
{
    if (_selectAssetArray == nil)
    {
        _selectAssetArray = [NSMutableArray array];
    }
    return _selectAssetArray;
}
#pragma mark - XXBMediaTableViewDataSouce

- (NSInteger)numberOfSectionsInTableView
{
    return self.sectionFetchResults.count;
}

- (NSInteger)numberOfRowsInTableViewSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if (section == 0)
    {
        numberOfRows = 1;
    }
    else
    {
        PHFetchResult *fetchResult = self.sectionFetchResults[section];
        numberOfRows = fetchResult.count;
    }
    return numberOfRows;
}

- (NSString *)titleOfIndex:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return  @"全部照片";
    }
    else
    {
        PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
        PHCollection *collection = fetchResult[indexPath.row];
        return  collection.localizedTitle;
    }
}

- (id<XXBMediaAssetDataSouce>)imageOfIndex:(NSIndexPath *)indexPath
{
    if(indexPath.section >= self.sectionFetchResults.count) {
        return nil;
    }
    id<XXBMediaAssetDataSouce> result = nil;
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    if (indexPath.section == 0)
    {
        if (indexPath.row >= fetchResult.count) {
            return nil;
        }
        result = [fetchResult objectAtIndex:0];
    }
    else
    {
        PHCollection *collection = fetchResult[indexPath.row];
        if (![collection isKindOfClass:[PHAssetCollection class]])
        {
            return nil;
        }
        // Configure the AAPLAssetGridViewController with the asset collection.
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        result = [assetsFetchResult objectAtIndex:0];
    }
    return result;
}

- (void)didselectMediaGroupAtIndexPath:(NSIndexPath *)indexPath
{
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    
    if (indexPath.section == 0)
    {
        self.seleectPHFetchResult = fetchResult;
    }
    else
    {
        PHCollection *collection = fetchResult[indexPath.row];
        if (![collection isKindOfClass:[PHAssetCollection class]])
        {
            return;
        }
        // Configure the AAPLAssetGridViewController with the asset collection.
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        self.seleectPHFetchResult = assetsFetchResult;
    }
}

- (void)didselectMediaItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.seleectPHFetchResult.count)
    {
        return;
    }
    PHAsset *asset = self.seleectPHFetchResult[indexPath.row];
    NSInteger index = [self indexOfAssetInSelectedMediaAsset:asset];
    if (  index != NSNotFound)
    {
        [self.selectAssetArray removeObject:asset];
        NSMutableArray *cellIndexArray = [NSMutableArray array];
        NSInteger count = self.selectAssetArray.count;
        while (count > index)
        {
            count --;
            PHAsset *asset = self.selectAssetArray[count];
            NSInteger assetIndex = [self.seleectPHFetchResult indexOfObject:asset];
            if (assetIndex != NSNotFound)
            {
                [cellIndexArray addObject:[NSIndexPath indexPathForRow:assetIndex inSection:0]];
            }
        }
        /**
         *  刷新列表防止顺序错乱
         */
        [self.collectionView reloadItemsAtIndexPaths:cellIndexArray];
        
    }
    else
    {
        [self.selectAssetArray addObject:self.seleectPHFetchResult[indexPath.row]];
    }
}

#pragma mark - XXBMediaCollectionViewViewDataSouce

- (NSInteger)numberOfRowsInCollectionViewSection:(NSInteger)section
{
    return self.seleectPHFetchResult.count + 1;
}
- (NSInteger)numberOfSectionsInCollectionView
{
    return 1;
}

- (id)mediaAssetOfIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.seleectPHFetchResult.count)
    {
        return self.seleectPHFetchResult[indexPath.row];;
    }
    else
    {
        return nil;
    }
}
@end
