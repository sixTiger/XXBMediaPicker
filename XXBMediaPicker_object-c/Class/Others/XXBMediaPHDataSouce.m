//
//  XXBMediaDataSouce.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPHDataSouce.h"

@interface XXBMediaPHDataSouce ()<PHPhotoLibraryChangeObserver>

@property(nonatomic , strong) NSArray   *sectionFetchResults;
@property(nonatomic , strong) PHFetchResult   *seleectPHFetchResult;

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
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self p_registerPhotoServers];
    }
    return self;
}

/**
 *  注册相册服务
 */
- (void)p_registerPhotoServers
{
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    PHFetchOptions *smartAlbumsOptions = [[PHFetchOptions alloc] init];
    smartAlbumsOptions.fetchLimit = 1;
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:smartAlbumsOptions];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    self.sectionFetchResults = @[allPhotos, smartAlbums, topLevelUserCollections];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
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
        [self.collectionView reloadData];
        
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
            //[collectionView performBatchUpdates:^{
            //    NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
            //    if ([removedIndexes count] > 0) {
            //        [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
            //    }
            //
            //    NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
            //    if ([insertedIndexes count] > 0) {
            //        [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
            //    }
            //
            //    NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
            //    if ([changedIndexes count] > 0) {
            //        [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
            //    }
            //} completion:NULL];
        }
        
    });
    
}


- (void)setSectionFetchResults:(NSArray *)sectionFetchResults
{
    _sectionFetchResults = sectionFetchResults;
//    NSMutableArray *updatedSectionFetchResults = [_sectionFetchResults mutableCopy];
//    __block BOOL reloadRequired = NO;
//    [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
//            [updatedSectionFetchResults removeObjectAtIndex:index];
//            reloadRequired = YES;
//    }];
//    
//    if (reloadRequired)
//    {
//        _sectionFetchResults = updatedSectionFetchResults;
//    }

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


#pragma mark - XXBMediaCollectionViewViewDataSouce

- (NSInteger)numberOfRowsInCollectionViewSection:(NSInteger)section
{
    return self.seleectPHFetchResult.count;
}
- (NSInteger)numberOfSectionsInCollectionView
{
    return 1;
}
@end
