//
//  XXBMediaALDataSouce.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/5/27.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaALDataSouce.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAsset+XXBMediaALAsset.h"

@interface XXBMediaALDataSouce ()

/**
 *  当前展示数据的 tableView
 */
@property(nonatomic , weak) UITableView             *tableView;
/**
 *  当前展示数据的 collectionView
 */
@property(nonatomic , weak) UICollectionView        *collectionView;

@property(nonatomic , strong) ALAssetsLibrary       *assetsLibrary;
@property (nonatomic, strong) ALAssetsGroup         *selectAssetsGroup;
@property (nonatomic, strong) NSMutableArray        *groups;
@property(nonatomic , strong) NSMutableArray        *assetArray;
@property (nonatomic, strong) ALAssetsFilter        *assetsFilter;
@property (nonatomic, strong) NSMutableDictionary   *observers;
@property (nonatomic, strong) NSMutableArray        *extraAssets;
@property(nonatomic , strong) NSMutableArray        *selectedAssetArray;
@property (nonatomic, assign) BOOL                  ignoreMediaNotifications;
@property (nonatomic, assign) BOOL                  refreshGroups;
@end

@implementation XXBMediaALDataSouce
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

+ (instancetype)sharedXXBMediaALDataSouce {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addNotifaction];
        [self loadData];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addNotifaction {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLibraryNotification:)
                                                 name:ALAssetsLibraryChangedNotification
                                               object:self.assetsLibrary];
}

- (void)loadData {
    self.refreshGroups = YES;
    [self loadDataWithSuccess:^{
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
    }];
}

- (void)handleLibraryNotification:(NSNotification *)note {
    if (![self shouldNotifyObservers:note]) {
        return;
    }
    if (self.ignoreMediaNotifications) {
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf loadDataWithSuccess:^{
            [weakSelf.observers enumerateKeysAndObjectsUsingBlock:^(NSUUID *key, XXBMediaChangesBlock block, BOOL *stop) {
                block();
            }];
        } failure:nil];
    });
}

- (BOOL)shouldNotifyObservers:(NSNotification *)note
{
    if (!note.userInfo ||
        note.userInfo[ALAssetLibraryUpdatedAssetGroupsKey] ||
        [note.userInfo[ALAssetLibraryInsertedAssetGroupsKey] count] > 0 ||
        [note.userInfo[ALAssetLibraryDeletedAssetGroupsKey] count] > 0
        ) {
        self.refreshGroups = YES;
        return YES;
    }
    NSURL *currentGroupID = [self.selectAssetsGroup valueForProperty:ALAssetsGroupPropertyURL];
    NSSet *groupsChanged = note.userInfo[ALAssetLibraryUpdatedAssetGroupsKey];
    NSSet *assetsChanged = note.userInfo[ALAssetLibraryUpdatedAssetsKey];
    if (  groupsChanged && [groupsChanged containsObject:currentGroupID]
        && assetsChanged.count > 0
        ) {
        return YES;
    }
    return NO;
}

- (void)loadDataWithSuccess:(XXBMediaChangesBlock)successBlock
                    failure:(XXBMediaFailureBlock)failureBlock
{
    ALAuthorizationStatus authorizationStatus = ALAssetsLibrary.authorizationStatus;
    if (authorizationStatus == ALAuthorizationStatusDenied ||
        authorizationStatus == ALAuthorizationStatusRestricted) {
        if (failureBlock) {
            NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:nil];
            failureBlock(error);
        }
        return;
    }
    [self.extraAssets removeAllObjects];
    if (self.refreshGroups) {
        [self loadGroupsWithSuccess:^{
            self.refreshGroups = NO;
            [self loadAssetsWithSuccess:successBlock failure:failureBlock];
        } failure:failureBlock];
    } else {
        [self loadAssetsWithSuccess:successBlock failure:failureBlock];
    }
}

- (void)loadGroupsWithSuccess:(XXBMediaChangesBlock)successBlock failure:(XXBMediaFailureBlock)failureBlock {
    [self.groups removeAllObjects];
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(!group){
            if (successBlock) {
                successBlock();
            }
            return;
        }
        if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos){
            if (!self.selectAssetsGroup){
                self.selectAssetsGroup = group;
            }
            [self.groups insertObject:group atIndex:0];
        } else {
            [self.groups addObject:group];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        NSError * filteredError = error;
        if ([error.domain isEqualToString:ALAssetsLibraryErrorDomain] &&
            (error.code == ALAssetsLibraryAccessUserDeniedError || error.code == ALAssetsLibraryAccessGloballyDeniedError)
            ) {
            filteredError = [NSError errorWithDomain:@"Error" code:-1 userInfo:error.userInfo];
        }
        if (failureBlock) {
            failureBlock(filteredError);
        }
    }];
}

- (void)loadAssetsWithSuccess:(XXBMediaChangesBlock)successBlock failure:(XXBMediaFailureBlock)failureBlock {
    [self.selectAssetsGroup setAssetsFilter:self.assetsFilter];
    if (successBlock) {
        successBlock();
    }
}

#pragma mark - layz Load

- (NSMutableArray *)groups {
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (NSMutableArray *)assetArray {
    if (_assetArray == nil) {
        _assetArray = [NSMutableArray array];
    }
    return _assetArray;
}
- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

#pragma mark - XXBMediaDataSouce

- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
}

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    [tableView reloadData];
}

/**
 *  选中的对应的分组
 *
 *  @param indexParh
 */
- (void)didselectMediaGroupAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectAssetsGroup = self.groups[indexPath.row];
    [self loadAssetsWithSuccess:^{
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  选中的对应的分组
 *
 *  @param indexPath
 */
- (void)didselectMediaItemAtIndexPath:(NSIndexPath *)indexPath {
}

/**
 *  mediaAsset 在选中的数组中的下表
 */
- (NSUInteger)indexOfAssetInSelectedMediaAsset:(id<XXBMediaAssetDataSouce>)mediaAsset {
    return 0;
}

/**
 *  当前选中的媒体资源
 *
 *  @return 当前选中的媒体资源数组
 */
- (NSArray *)selectAsset {
    return self.selectedAssetArray;
}


#pragma mark - XXBMediaTableViewDataSouce
/**
 *  有多少组
 *
 *  @param mediaTableViewDataSouce 默认是0
 *
 *  @return 组数
 */
- (NSInteger)numberOfSectionsInTableView {
    return self.groups.count;
}
/**
 *  对应的组里边有多少数据
 *
 *  @param mediaTableViewDataSouce 实现协议的类
 *  @param section                 对应的组
 *
 *  @return 个数
 */
- (NSInteger)numberOfRowsInTableViewSection:(NSInteger)section {
    return self.groups.count;
}

/**
 *  返回对应的标题
 *
 *  @return 标题
 */
- (NSString *)titleOfIndex:(NSIndexPath *)indexPath {
    return [self.groups[indexPath.row] name];
}

/**
 *  返回对应的分组的第一个图片资源
 *
 *  @return 第一个图片资源
 */
- (id <XXBMediaAssetDataSouce>)mediaGroupAssetOFIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UIImage *)imageOfIndexPath:(NSIndexPath *)indexPath {
    return [UIImage imageWithCGImage:[self.groups[indexPath.row] posterImage]];
}

#pragma mark - XXBMediaCollectionDataSouce

- (NSInteger) numberOfSectionsInCollectionView {
    return 1;
}

- (NSInteger) numberOfRowsInCollectionViewSection:(NSInteger)section {
    return [self.selectAssetsGroup numberOfAssets] + 1;
}

/**
 *  对应的indexPath 的 XXBMediaAsset
 *
 *  @param indexPath
 *
 *  @return XXBMediaAsset
 */
- (id<XXBMediaAssetDataSouce>) mediaAssetOfIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.selectAssetsGroup numberOfAssets]) {
        return nil;
    }
    __block ALAsset *asset;
    [self.selectAssetsGroup enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:indexPath.row]
                                             options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                 if (result){
                                                     asset = result;
                                                 }
                                             }];
    return asset;
}

@end


#pragma mark - WPALAssetGroup

@implementation ALAssetsGroup(WPALAssetGroup)

- (NSString *)name {
    return [self valueForProperty:ALAssetsGroupPropertyName];
}

- (id)baseGroup {
    return self;
}

- (NSString *)identifier {
    return [[self valueForProperty:ALAssetsGroupPropertyURL] absoluteString];
}

@end
