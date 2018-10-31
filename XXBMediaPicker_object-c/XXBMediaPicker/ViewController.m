//
//  ViewController.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "ViewController.h"
#import "XXBMediaPicker.h"

@interface ViewController ()<XXBMediaPickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic , weak)UICollectionView     *collectionView;
@property(nonatomic , strong)NSMutableArray     *photoArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"open" style:UIBarButtonItemStylePlain target:self action:@selector(p_choosePhotos)];
}

- (void)p_choosePhotos {
    
    XXBMediaPickerConfigure *mediaPickerConfigure = [[XXBMediaPickerConfigure alloc] init];
    mediaPickerConfigure.enableBageValue = NO;
    mediaPickerConfigure.maxSelectCount = 2;
    XXBMediaPickerController * mediaPickerController = [XXBMediaPickerController mediaPickerControllerWithConfigure:mediaPickerConfigure];
    mediaPickerController.delegate = self;
    [self presentViewController:mediaPickerController animated:YES completion:nil];
}

- (void)p_choosePhotos2 {
    
    XXBMediaPickerConfigure *mediaPickerConfigure = [[XXBMediaPickerConfigure alloc] init];
    mediaPickerConfigure.enableBageValue = NO;
    mediaPickerConfigure.maxSelectCount = 2;
    XXBMediaPickerController * mediaPickerController = [XXBMediaPickerController mediaPickerControllerWithConfigure:mediaPickerConfigure];
    mediaPickerController.delegate = self;
    [self presentViewController:mediaPickerController animated:YES completion:nil];
}
- (void)mediaPickerControllerCancleDidClick:(XXBMediaPickerController *)mediaPickerController {
    
}

- (void)mediaPickerControllerFinishDidClick:(XXBMediaPickerController *)mediaPickerController andSlectedMedias:(NSArray *)selectMediaArray {
    [self.photoArray removeAllObjects];
    [self.photoArray addObjectsFromArray:selectMediaArray];
    [mediaPickerController dismissViewControllerAnimated:YES completion:^{
        [self.collectionView reloadData];
        [self.view bringSubviewToFront:self.collectionView];
    }];
}



#pragma mark - 返回的图片的链接的处理
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 104);
        layout.minimumInteritemSpacing = 20;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(84, 10, 20, 10);
        UICollectionView *collectionView  = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor yellowColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.autoresizingMask = (1 << 6) -1;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
        imageView.image = [UIImage imageNamed:@"bg"];
        collectionView.backgroundView =imageView;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        _collectionView = collectionView;
        [self.view addSubview:collectionView];
        [self.view bringSubviewToFront:collectionView];
    }
    return _collectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    cell.backgroundView = imageView;
    imageView.contentMode = UIViewContentModeScaleToFill;
    PHAsset *photoAsset = self.photoArray[indexPath.row];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // Download from cloud if necessary
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    };
    [[PHImageManager defaultManager] requestImageDataForAsset:photoAsset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        imageView.image = [UIImage imageWithData:imageData];
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (NSMutableArray *)photoArray {
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
@end
