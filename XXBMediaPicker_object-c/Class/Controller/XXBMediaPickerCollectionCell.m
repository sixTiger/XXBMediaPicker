//
//  XXBMediaPickerCollectionCell.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerCollectionCell.h"
#import "PHAsset+XXBMediaPHAsset.h"

@interface XXBMediaPickerCollectionCell ()
@property(nonatomic , weak) UIImageView   *imageView;
//@property(nonatomic , strong) UIImage   *image;
@end

@implementation XXBMediaPickerCollectionCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
}

- (void)setMediaAsset:(id<XXBMediaAssetDataSouce>)mediaAsset
{
    _mediaAsset = mediaAsset;
    __block XXBMediaRequestID requestKey = 0;
//    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    requestKey = [_mediaAsset imageWithSize:self.frame.size completionHandler:^(UIImage *result, NSError *error) {
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        // Did this request changed meanwhile
        if (requestKey != self.tag)
        {
            return;
        }
        if ([NSThread isMainThread])
        {
            self.imageView.image = result;
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = result;
            });
        }
    }];
    self.tag = requestKey;
//    NSString *label = @"";
//    NSString *caption = @"";
//    WPMediaType assetType = _asset.assetType;
//    switch (assetType) {
//        case WPMediaTypeImage:
//            label = [NSString stringWithFormat:NSLocalizedString(@"Image, %@", @"Accessibility label for image thumbnails in the media collection view. The parameter is the creation date of the image."),
//                     [[[self class] dateFormatter] stringFromDate:_asset.date]];
//            break;
//        case WPMediaTypeVideo:
//            label = [NSString stringWithFormat:NSLocalizedString(@"Video, %@", @"Accessibility label for video thumbnails in the media collection view. The parameter is the creation date of the video."),
//                     [[[self class] dateFormatter] stringFromDate:_asset.date]];
//            NSTimeInterval duration = [asset duration];
//            caption = [self stringFromTimeInterval:duration];
//            break;
//        default:
//            break;
//    }
//    self.imageView.accessibilityLabel = label;
//    [self setCaption:caption];
}


- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:imageView];
        imageView.autoresizingMask = (1 << 6) - 1;
        _imageView = imageView;
    }
    return _imageView;
}
@end
