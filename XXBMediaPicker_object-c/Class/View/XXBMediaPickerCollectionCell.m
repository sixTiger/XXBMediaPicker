//
//  XXBMediaPickerCollectionCell.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerCollectionCell.h"
#import "PHAsset+XXBMediaPHAsset.h"
#import "XXBMediaDataSource.h"
#import "XXBBadgeValueBtn.h"

@interface XXBMediaPickerCollectionCell ()

@property(nonatomic , weak) UIImageView         *imageView;

@property(nonatomic , weak) UIView              *coverView;
/**
 选中的对号
 */
@property(nonatomic , weak)UIButton             *selectButton;
@property(nonatomic , weak)XXBBadgeValueBtn     *bageButton;
@property(nonatomic , weak)UILabel              *messageLabel;
@property(nonatomic , weak)UIView               *videoBgView;
@property(nonatomic , weak)UIImageView          *videoIconView;
@property(nonatomic, assign)BOOL                mediaSelected;
@property(nonatomic, assign)XXBMediaRequestID   requestKey;


@end

@implementation XXBMediaPickerCollectionCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
}

- (void)setMediaAsset:(id<XXBMediaAssetDataSource>)mediaAsset {
    NSInteger index = [[XXBMediaDataSource sharedMediaDataSouce].dataSouce indexOfAssetInSelectedMediaAsset:mediaAsset];
    if (index != NSNotFound) {
        self.mediaSelected = YES;
        [self.bageButton setBadgeValue:index + 1];
    } else {
        [self.bageButton setBadgeValue:0];
        self.mediaSelected = NO;
    }
    if ([_mediaAsset isEqual:mediaAsset]) {
        return;
    } else {
        [_mediaAsset cancelImageRequest:self.requestKey];
    }
    _mediaAsset = mediaAsset;
    __weak typeof(self) weakSelf = self;
    self.requestKey = [_mediaAsset imageWithSize:self.frame.size completionHandler:^(UIImage *result, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        if ([NSThread isMainThread]) {
            strongSelf.imageView.image = result;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.imageView.image = result;
            });
        }
    }];
    XXBMediaType mediaType = [mediaAsset mediaAssetType];
    switch (mediaType) {
        case XXBMediaTypeUnknown:
        {
            _messageLabel.text = nil;
            _videoBgView.hidden = YES;
            _videoIconView.hidden = YES;
            break;
        }
        case XXBMediaTypeImage:
        {
            _messageLabel.text = nil;
            _videoBgView.hidden = YES;
            _videoIconView.hidden = YES;
            break;
        }
        case XXBMediaTypeVideo:
        {
            self.videoBgView.hidden = NO;
            self.videoIconView.hidden = NO;
            self.messageLabel.text = [self timeFromeNumber:(int)([mediaAsset mediaAssetTime])];
            break;
        }
        case XXBMediaTypeAudio:
        {
            self.videoBgView.hidden = NO;
            self.videoIconView.hidden = NO;
            self.messageLabel.text = [self timeFromeNumber:(int)([mediaAsset mediaAssetTime])];
            break;
        }
        case XXBMediaTypeLivePhoto:
        {
            _messageLabel.text = nil;
            _videoBgView.hidden = YES;
            _videoIconView.hidden = YES;
            self.videoIconView.hidden = NO;
            break;
        }
        default:
            break;
    }
}

- (void)setMediaSelected:(BOOL)mediaSelected {
    _mediaSelected = mediaSelected;
    if (mediaSelected) {
        self.coverView.backgroundColor = [UIColor clearColor];
    }
    self.selectButton.selected = mediaSelected;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        imageView.autoresizingMask = (1 << 6) - 1;
        _imageView = imageView;
    }
    return _imageView;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        UIView *coverView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView insertSubview:coverView aboveSubview:self.imageView];
        coverView.autoresizingMask = (1 << 6) - 1;
        _coverView = coverView;
    }
    return _coverView;
}

- (UIButton *)selectButton{
    if (_selectButton == nil) {
        //右上角的小图标的尺寸
        CGFloat margin = 5.0;
        CGFloat width = 22;
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake(self.bounds.size.width - width - margin,  margin , width , width);
        [self.coverView addSubview:selectButton];
        //FIXME: 预先展示的图片可以去掉
        [selectButton setImage:[UIImage imageNamed:@"XXBPhoto"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"XXBPhotoSelected"] forState:UIControlStateSelected];
        selectButton.userInteractionEnabled = NO;
        _selectButton =selectButton;
    }
    return _selectButton;
}

- (XXBBadgeValueBtn *)bageButton {
    if (_bageButton == nil ) {
        XXBBadgeValueBtn *bageButton = [[XXBBadgeValueBtn alloc] init];
        [self.coverView addSubview:bageButton];
        bageButton.frame = CGRectMake(5, 5, 10, 10);
        _bageButton = bageButton;
    }
    return _bageButton;
}


- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        messageLabel.font = [UIFont systemFontOfSize:12];
        messageLabel.textColor = [UIColor whiteColor];
        [self.videoBgView addSubview:messageLabel];
        messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *rightMessageLabel = [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.videoBgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-3];
        NSLayoutConstraint *bottomMessageLabel = [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: self.videoBgView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *topMessageLabel = [NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: self.videoBgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        
        [self.videoBgView addConstraints:@[rightMessageLabel, bottomMessageLabel,topMessageLabel]];
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}

- (UIView *)videoBgView {
    if (_videoBgView == nil) {
        UIView *videoBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        videoBgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [self.contentView addSubview:videoBgView];
        videoBgView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *lefttVideoBgView = [NSLayoutConstraint constraintWithItem:videoBgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *rightVideoBgView = [NSLayoutConstraint constraintWithItem:videoBgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *bottomVideoBgView = [NSLayoutConstraint constraintWithItem:videoBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *heightVideoBgView = [NSLayoutConstraint constraintWithItem:videoBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem: nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        [self.contentView addConstraints:@[lefttVideoBgView, rightVideoBgView,bottomVideoBgView,heightVideoBgView]];
        _videoBgView = videoBgView;
    }
    return _videoBgView;
}

- (UIImageView *)videoIconView {
    if (_videoIconView == nil) {
        UIImageView *videoIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        videoIconView.image = [UIImage imageNamed:@"XXBVideo_L_B"];
        videoIconView.contentMode = UIViewContentModeCenter;
        [self.videoBgView addSubview:videoIconView];
        videoIconView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *lefttVideoBgView = [NSLayoutConstraint constraintWithItem:videoIconView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.videoBgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *bottomVideoBgView = [NSLayoutConstraint constraintWithItem:videoIconView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: self.videoBgView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *heightVideoBgView = [NSLayoutConstraint constraintWithItem:videoIconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem: self.videoBgView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        NSLayoutConstraint *wightVideoBgView = [NSLayoutConstraint constraintWithItem:videoIconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem: self.videoBgView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        [self.contentView addConstraints:@[lefttVideoBgView,bottomVideoBgView,heightVideoBgView,wightVideoBgView]];
        _videoIconView = videoIconView;
    }
    return _videoIconView;
}

- (NSString *)timeFromeNumber:(int )second {
    int times[3];
    memset(times, 0, sizeof(times));
    int i = 0;
    while (i < 2) {
        int time = second % 60;
        second /= 60;
        times[i] = time;
        i ++;
    }
    times[i] = second;
    NSString * time = @"";
    while (i > 0) {
        if (i >= 2 && times[i] <= 0 && time.length <= 0) {
            i-- ;
            continue;
        }
        time = [NSString stringWithFormat:@"%@%02d:",time,times[i]];
        i--;
    }
    time = [NSString stringWithFormat:@"%@%02d",time,times[i]];
    return time;
}

- (void)setEnableBage:(BOOL)enableBage {
    _enableBage = enableBage;
    self.bageButton.enable = enableBage;
}

- (void)setShowCoverView:(BOOL)showCoverView {
    _showCoverView = showCoverView;
    if (!showCoverView || self.mediaSelected) {
        self.coverView.backgroundColor = [UIColor clearColor];
    } else {
        self.coverView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    }
}
@end
