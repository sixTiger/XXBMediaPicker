//
//  XXBMediaPickerCollectionCell.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerCollectionCell.h"
#import "PHAsset+XXBMediaPHAsset.h"
#import "XXBMediaDataSouce.h"
#import "XXBBadgeValueBtn.h"

@interface XXBMediaPickerCollectionCell ()
@property(nonatomic , weak) UIImageView         *imageView;

@property(nonatomic , weak) UIView              *coverView;
@property(nonatomic , weak)UIButton             *coverButton;
@property(nonatomic , weak)XXBBadgeValueBtn     *bageButton;
@property(nonatomic , weak) UILabel             *messageLabel;
@property(nonatomic , weak) UIView              *videoBgView;
@end

@implementation XXBMediaPickerCollectionCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
}

- (void)setMediaAsset:(id<XXBMediaAssetDataSouce>)mediaAsset
{
    NSInteger index = [[XXBMediaDataSouce sharedMediaDataSouce].dataSouce indexOfAssetInSelectedMediaAsset:mediaAsset];
    if (index != NSNotFound)
    {
        self.selected = YES;
        [self.bageButton setBadgeValue:index + 1];
    }
    else
    {
        [self.bageButton setBadgeValue:0];
        self.selected = NO;
    }

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
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.coverView.backgroundColor = selected ? [UIColor colorWithWhite:1.0 alpha:0.3] : [UIColor clearColor];
    self.coverButton.selected = selected;
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

- (UIView *)coverView
{
    if (_coverView == nil)
    {
        UIView *coverView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView insertSubview:coverView aboveSubview:self.imageView];
        coverView.autoresizingMask = (1 << 6) - 1;
        _coverView = coverView;
    }
    return _coverView;
}

- (UIButton *)coverButton
{
    if (_coverButton == nil)
    {
        //右上角的小图标的尺寸
        CGFloat margin = 5.0;
        CGFloat width = 22;
        UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        coverButton.frame = CGRectMake(self.bounds.size.width - width - margin,  margin , width , width);
        [self.coverView addSubview:coverButton];
//FIXME: 预先展示的图片可以去掉
        [coverButton setImage:[UIImage imageNamed:@"XXBPhoto"] forState:UIControlStateNormal];
        [coverButton setImage:[UIImage imageNamed:@"XXBPhotoSelected"] forState:UIControlStateSelected];
        coverButton.userInteractionEnabled = NO;
        _coverButton =coverButton;
    }
    return _coverButton;
}

- (XXBBadgeValueBtn *)bageButton
{
    if (_bageButton == nil )
    {
        XXBBadgeValueBtn *bageButton = [[XXBBadgeValueBtn alloc] init];
        [self.coverView addSubview:bageButton];
        bageButton.frame = CGRectMake(5, 5, 10, 10);
        _bageButton = bageButton;
    }
    return _bageButton;
}
@end
