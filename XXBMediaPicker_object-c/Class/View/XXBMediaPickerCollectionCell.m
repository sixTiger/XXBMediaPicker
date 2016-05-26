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
@property(nonatomic , weak) UIImageView         *videoIconView;
@end

@implementation XXBMediaPickerCollectionCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
}

- (void)setMediaAsset:(id<XXBMediaAssetDataSouce>)mediaAsset {
    NSInteger index = [[XXBMediaDataSouce sharedMediaDataSouce].dataSouce indexOfAssetInSelectedMediaAsset:mediaAsset];
    if (index != NSNotFound) {
        self.selected = YES;
        [self.bageButton setBadgeValue:index + 1];
    } else {
        [self.bageButton setBadgeValue:0];
        self.selected = NO;
    }
    
    _mediaAsset = mediaAsset;
    __block XXBMediaRequestID requestKey = -1;
    self.tag = requestKey;
    //    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    requestKey = [_mediaAsset imageWithSize:self.frame.size completionHandler:^(UIImage *result, NSError *error) {
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        // Did this request changed meanwhile
        if (requestKey != self.tag) {
            return;
        }
        if ([NSThread isMainThread]) {
            self.imageView.image = result;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = result;
            });
        }
    }];
    self.tag = requestKey;
    
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

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.coverView.backgroundColor = selected ? [UIColor colorWithWhite:1.0 alpha:0.3] : [UIColor clearColor];
    self.coverButton.selected = selected;
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

- (UIButton *)coverButton {
    if (_coverButton == nil) {
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
@end
