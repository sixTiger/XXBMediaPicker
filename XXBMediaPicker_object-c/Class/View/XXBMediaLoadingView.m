//
//  XXBMediaLoadingView.m
//  XXBMediaPicker
//
//  Created by xiaobing5 on 2018/11/1.
//  Copyright © 2018 xiaobing. All rights reserved.
//

#import "XXBMediaLoadingView.h"

@interface XXBMediaLoadingView()
@property(nonatomic, weak) UIView                       *loadingBGView;
@property(nonatomic, weak) UIActivityIndicatorView      *activityIndicatorView;
@end

@implementation XXBMediaLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidesWhenStopped = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.loadingBGView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
}

- (void)startAnimating {
    if (self.hidesWhenStopped) {
        self.hidden = NO;
    }
    [self.activityIndicatorView startAnimating];
}

- (void)stopAnimating {
    [self.activityIndicatorView stopAnimating];
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    _hidesWhenStopped = hidesWhenStopped;
    self.activityIndicatorView.hidesWhenStopped = hidesWhenStopped;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.loadingBGView addSubview:activityIndicatorView];
        activityIndicatorView.center = CGPointMake(CGRectGetWidth(self.loadingBGView.frame) * 0.5, CGRectGetHeight(self.loadingBGView.frame) * 0.5);
        _activityIndicatorView = activityIndicatorView;
    }
    return _activityIndicatorView;
}

- (UIView *)loadingBGView {
    if (_loadingBGView == nil) {
        UIView *loadingBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        loadingBGView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        loadingBGView.layer.cornerRadius = 4;
        loadingBGView.clipsToBounds = YES;
        [self addSubview:loadingBGView];
        _loadingBGView = loadingBGView;
    }
    return _loadingBGView;
}
@end
