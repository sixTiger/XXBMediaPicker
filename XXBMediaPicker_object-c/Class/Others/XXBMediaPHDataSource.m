//
//  XXBMediaDataSouce.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPHDataSource.h"
#import "NSIndexSet+Convenience.h"
#import "PHAsset+XXBMediaPHAsset.h"
#import "XXBMediaConsts.h"

@interface XXBMediaPHDataSource ()<PHPhotoLibraryChangeObserver>

/**
 是否正在加载全部资源
 */
@property(nonatomic, assign) BOOL                   isLoadingAllSectionsData;

/**
 是否正在加载选中的资源资源
 */
@property(nonatomic, assign) BOOL                   isLoadingSelectSectionsData;


/**
 *  当前展示数据的 tableView
 */
@property(nonatomic , weak) UITableView             *tableView;

/**
 *  当前展示数据的 collectionView
 */
@property(nonatomic , weak) UICollectionView        *collectionView;

/**
 当前所有的分组
 */
@property(nonatomic , strong) NSMutableArray        *sectionFetchResults;

/**
 当前选中的组
 */
@property(nonatomic , strong) PHFetchResult         *seleectPHFetchResult;

/**
 当前选中的Asset
 */
@property(nonatomic , strong) NSMutableArray        *selectAssetArray;

@property(nonatomic, copy) NSString                 *selectlocalPHCollectionIdentifier;
@end

@implementation XXBMediaPHDataSource

static id _instance = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

+ (instancetype)sharedXXBMediaPHDataSource {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super alloc] init];
    });
    return _instance;
}

+ (PHImageManager *) sharedImageManager {
    static id _sharedImageManager = nil;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedImageManager = [[PHCachingImageManager alloc] init];
    });
    return _sharedImageManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self authorizationStatusAuthorized:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                {
                    [self loadLastSelectlocalPHCollectionIdentifier];
                    [self p_loadPhotos];
                    [self p_registerPhotoServers];
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return self;
}

#pragma mark - 获取系统的照片
/**
 *  注册相册服务
 */
- (void)p_registerPhotoServers {
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)p_loadPhotos {
    [self p_loadLastSelectData:^{
        [self p_loadAllPhotos];
    }];
}

- (void)p_loadLastSelectData:(void (^)(void))completion {
    @synchronized (self) {
        self.isLoadingSelectSectionsData = YES;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadLocalSelectlocalPHCollection:^(BOOL haveData) {
            if (haveData) {
                //图片库资源加载完成通知
                @synchronized (self) {
                    self.isLoadingSelectSectionsData = NO;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kXXBMediaCurrentSelectSectionsDataCompletion object:nil userInfo:nil];
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }];
    });
}

- (void)p_loadAllPhotos {
    @synchronized (self) {
        self.isLoadingAllSectionsData = YES;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized (self.sectionFetchResults) {
            [self.sectionFetchResults removeAllObjects];
        }
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
        @synchronized (self.sectionFetchResults) {
            [self.sectionFetchResults addObject:allPhotos];
        }
        for (PHAssetCollectionSubtype i = 201; i < 212; i++) {
            if (i == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded || i == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                // 最近添加的忽略 相机交卷忽略
                continue;
            }
            
            PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:i options:nil];
            PHCollection *collection = [smartAlbums firstObject];
            if (![collection isKindOfClass:[PHAssetCollection class]]) {
                return;
            }
            // Configure the AAPLAssetGridViewController with the asset collection.
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            if (assetsFetchResult.count > 0) {
                @synchronized (self.sectionFetchResults) {
                    [self.sectionFetchResults addObject:smartAlbums];
                }
            }
        }
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        @synchronized (self.sectionFetchResults) {
            [self.sectionFetchResults addObject:topLevelUserCollections];
        }
        if (self.seleectPHFetchResult == nil) {
            self.seleectPHFetchResult = [self.sectionFetchResults firstObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                //默认选中全部照片
                [[NSNotificationCenter defaultCenter] postNotificationName:kXXBMediaCurrentSelectSectionsDataCompletion object:nil userInfo:nil];
            });
        }
        @synchronized (self) {
            self.isLoadingAllSectionsData = NO;
            self.isLoadingSelectSectionsData = NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //图片库资源加载完成通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kXXBMediaAllSectionsDataCompletion object:nil userInfo:nil];
        });
    });
}
- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
    /**
     *  看一下当前的是否有新创建的相册
     */
    // Loop through the section fetch results, replacing any fetch results that have been updated.
    __block BOOL reloadRequired = NO;
    @synchronized (self.sectionFetchResults) {
        NSMutableArray *updatedSectionFetchResults;
        updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            
            if (changeDetails != nil) {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        if (reloadRequired) {
            self.sectionFetchResults = updatedSectionFetchResults;
        }
    }
    if (reloadRequired) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
    
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.seleectPHFetchResult];
    if (collectionChanges == nil) {
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
    @synchronized (self.seleectPHFetchResult) {
        self.seleectPHFetchResult = [collectionChanges fetchResultAfterChanges];
    }
    
    if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
        
        // Reload the collection view if the incremental diffs are not available
        //如果删除/插入/更改的详细信息描述了对此获取结果的更改，则为YES。
        // NO表示更改范围太大，UI客户端应执行完全重新加载，无法提供增量更改
        //或者
        // 相册被移除
        
    } else {
        /*
         Tell the collection view to animate insertions and deletions if we
         have incremental diffs.
         */
        dispatch_async(dispatch_get_main_queue(), ^{
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
        });
    }
    NSArray *removeObjects  =  [collectionChanges removedObjects];
    // 当前选中的照片应该删除相应的选项
    for (id<XXBMediaAssetDataSource> media in removeObjects) {
        NSUInteger index = [self indexOfAssetInSelectedMediaAsset:media];
        if (index != NSNotFound ) {
            //如果当前删除的是被选中的，从选中分组里边移除
            @synchronized (self.selectAssetArray) {
                [self.selectAssetArray removeObjectAtIndex:index];
            }
        }
    }
}

- (NSUInteger)indexOfAssetInSelectedMediaAsset:(id<XXBMediaAssetDataSource>)mediaAsset {
    NSUInteger position = [self.selectAssetArray indexOfObjectPassingTest:^BOOL(id<XXBMediaAssetDataSource> loopAsset, NSUInteger idx, BOOL *stop) {
        return   [[mediaAsset identifier]  isEqual:[loopAsset identifier]];
    }];
    return position;
}

/**
 当前资源是否是选中的
 
 @param mediaAsset 资源
 @return 是否选中
 */
- (BOOL)isSelectedMediaAsset:(id<XXBMediaAssetDataSource>)mediaAsset {
    NSInteger index = [self indexOfAssetInSelectedMediaAsset:mediaAsset];
    if (index == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - layzeload

- (NSMutableArray *)sectionFetchResults {
    if (_sectionFetchResults == nil) {
        _sectionFetchResults = [NSMutableArray array];
    }
    return _sectionFetchResults;
}

- (NSMutableArray *)selectAssetArray {
    if (_selectAssetArray == nil) {
        _selectAssetArray = [NSMutableArray array];
    }
    return _selectAssetArray;
}

- (void)setSelectlocalPHCollectionIdentifier:(NSString *)selectlocalPHCollectionIdentifier {
    _selectlocalPHCollectionIdentifier = selectlocalPHCollectionIdentifier;
    [self saveLastSelectlocalPHCollectionIdentifier];
}
#pragma mark - XXBMediaTableViewDataSouce

- (BOOL)isAviable {
    PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
    BOOL aviable = NO;
    switch (photoStatus) {
        case PHAuthorizationStatusAuthorized:
        {
            aviable = YES;
            break;
        }
        case PHAuthorizationStatusNotDetermined:
        {
            aviable = NO;
            break;
        }
        case PHAuthorizationStatusRestricted:
        {
            aviable = NO;
            break;
        }
        case PHAuthorizationStatusDenied:
        {
            aviable = NO;
            break;
        }
        default:
        {
            aviable = NO;
            break;
        }
    }
    return aviable;
}

- (NSInteger)numberOfSectionsInTableView {
    return self.sectionFetchResults.count;
}

- (NSInteger)numberOfRowsInTableViewSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        numberOfRows = 1;
    } else {
        PHFetchResult *fetchResult = self.sectionFetchResults[section];
        numberOfRows = fetchResult.count;
    }
    return numberOfRows;
}

- (NSString *)titleOfIndex:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        PHFetchResult *fetchResult = [self.sectionFetchResults firstObject];
        return  [NSString stringWithFormat:@"全部照片 (%ld)",[fetchResult count]];
    } else {
        //TODO:Xiaobing - <添加照片总数>
        NSDate *date = [NSDate date];
        PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
        PHCollection *collection = fetchResult[indexPath.row];
        return  collection.localizedTitle;
    }
}

- (id<XXBMediaAssetDataSource>)mediaGroupAssetOFIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section >= self.sectionFetchResults.count) {
        return nil;
    }
    id<XXBMediaAssetDataSource> result = nil;
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    if (indexPath.section == 0) {
        result = [fetchResult firstObject];
    } else {
        PHCollection *collection = fetchResult[indexPath.row];
        if (![collection isKindOfClass:[PHAssetCollection class]]) {
            return nil;
        }
        // Configure the AAPLAssetGridViewController with the asset collection.
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        result = [assetsFetchResult firstObject];
    }
    return result;
}

- (void)didselectMediaGroupAtIndexPath:(NSIndexPath *)indexPath {
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    
    if (indexPath.section == 0) {
        self.selectlocalPHCollectionIdentifier = nil;
        self.seleectPHFetchResult = fetchResult;
    } else {
        PHCollection *collection = fetchResult[indexPath.row];
        if (![collection isKindOfClass:[PHAssetCollection class]]) {
            return;
        }
        self.selectlocalPHCollectionIdentifier = collection.localIdentifier;
        // Configure the AAPLAssetGridViewController with the asset collection.
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        self.seleectPHFetchResult = assetsFetchResult;
    }
}

- (void)didselectMediaItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.seleectPHFetchResult.count) {
        return;
    }
    PHAsset *asset = self.seleectPHFetchResult[indexPath.row];
    NSInteger index = [self indexOfAssetInSelectedMediaAsset:asset];
    if (  index != NSNotFound) {
        [self.selectAssetArray removeObject:asset];
        NSMutableArray *cellIndexArray = [NSMutableArray array];
        NSInteger count = self.selectAssetArray.count;
        while (count > index) {
            count --;
            PHAsset *asset = self.selectAssetArray[count];
            NSInteger assetIndex = [self.seleectPHFetchResult indexOfObject:asset];
            if (assetIndex != NSNotFound) {
                [cellIndexArray addObject:[NSIndexPath indexPathForRow:assetIndex inSection:0]];
            }
        }
        /**
         *  刷新列表防止顺序错乱
         */
        [self.collectionView reloadItemsAtIndexPaths:cellIndexArray];
    } else {
        [self.selectAssetArray addObject:self.seleectPHFetchResult[indexPath.row]];
    }
}

- (NSArray *)selectAsset {
    return self.selectAssetArray;
}


#pragma mark - XXBMediaCollectionViewViewDataSouce

- (NSInteger)numberOfRowsInCollectionViewSection:(NSInteger)section {
    return self.seleectPHFetchResult.count;
}

- (NSInteger)numberOfSectionsInCollectionView {
    return 1;
}

- (id)mediaAssetOfIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.seleectPHFetchResult.count) {
        return [self.seleectPHFetchResult objectAtIndex:indexPath.row];
    } else {
        return nil;
    }
}

#pragma mark - private

- (void)saveLastSelectlocalPHCollectionIdentifier {
    [[NSUserDefaults standardUserDefaults] setObject:self.selectlocalPHCollectionIdentifier forKey:kXXBMediaLastSelectlocalPHCollectionIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadLastSelectlocalPHCollectionIdentifier {
    self.selectlocalPHCollectionIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:kXXBMediaLastSelectlocalPHCollectionIdentifier];
}

- (void)loadLocalSelectlocalPHCollection:(void (^)(BOOL haveData))completion  {
    if (self.selectlocalPHCollectionIdentifier) {
        // 读取本地记录的历史
        PHAssetCollection *assetCollection = [[PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[self.selectlocalPHCollectionIdentifier] options:nil] firstObject];
        if (assetCollection) {
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            self.seleectPHFetchResult = assetsFetchResult;
            completion(YES);
        } else {
            completion(NO);
        }
    } else {
        completion(NO);
    }
}


/**
 申请授权
 
 @param completion 申请完的回调
 */
- (void)authorizationStatusAuthorized:(void (^)(PHAuthorizationStatus status))completion {
    PHAuthorizationStatus state = [PHPhotoLibrary authorizationStatus];
    if (state == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kXXBMediaAuthorizationStatusChange object:nil userInfo:nil];
            completion(status);
        }];
    } else {
        completion(state);
    }
}
@end
