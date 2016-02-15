//
//  XXBMediaPickerTableViewCell.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerTableViewCell.h"

@interface XXBMediaPickerTableViewCell ()
@property(nonatomic , weak) UILabel         *titleLabel;
@property(nonatomic , weak) UIImageView     *iconImageView;
@property(nonatomic , weak) UIImageView     *rightView;
@end
@implementation XXBMediaPickerTableViewCell


- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.titleLabel.text = title;
}

- (void)setAsset:(id<XXBMediaAssetDataSouce>)asset
{
    _asset = asset;
    
    __block XXBMediaRequestID requestKey = 0;
    requestKey = [_asset imageWithSize:CGSizeMake(80, 80) completionHandler:^(UIImage *result, NSError *error) {
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        // 结果返回的时候判断是否已经重用了cell
        if (requestKey != self.tag)
        {
            return;
        }
        if ([NSThread isMainThread])
        {
            self.iconImageView.image = result;
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.iconImageView.image = result;
            });
        }
    }];
    self.tag = requestKey;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    CGFloat margin = 2;
    self.iconImageView.frame = CGRectMake(margin, margin, height - margin * 2, height - margin * 2);
    self.titleLabel.frame = CGRectMake(margin + height, margin, width, height - margin * 2);
    self.rightView.frame = CGRectMake(width - height, 0, height, height);
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil)
    {
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self.contentView addSubview:iconImageView];
        iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        iconImageView.clipsToBounds = YES;
        _iconImageView = iconImageView;
        return _iconImageView;
    }
    return _iconImageView;
}

- (UIImageView *)rightView
{
    if (_rightView == nil)
    {
        UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        rightView.contentMode = UIViewContentModeCenter;
        rightView.image = [UIImage imageNamed:@"XXBMakePhotoRow"];
        [self.contentView addSubview:rightView];
        _rightView = rightView;
    }
    return _rightView;
}
@end
