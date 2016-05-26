//
//  XXBBadgeValue.m
//  Pix72
//
//  Created by 杨小兵 on 15/6/2.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBBadgeValueBtn.h"
@implementation XXBBadgeValueBtn
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.hidden = YES;
    self.userInteractionEnabled = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.clipsToBounds = YES;
    UIImage *image = [UIImage imageNamed:@"XXBPageNumber"];
    [self setBackgroundImage:[image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5] forState:UIControlStateNormal];
}

- (void)setBadgeValue:(NSInteger)badgeValue {
    if (_badgeValue == badgeValue) {
        return;
    }
    _badgeValue = badgeValue;
    if (_badgeValue > 0) {
        NSString *bageString = [NSString stringWithFormat:@"%@",@(_badgeValue)];
        /**
         *  有值并且值不等于1 的情况向才进行相关设置
         */
        self.hidden = NO;
        if (_badgeValue > maxBadgeValue) {
            _badgeValue= maxBadgeValue;
            bageString = [NSString stringWithFormat:@"%@+",@(_badgeValue)];
        }
        [self setTitle:bageString forState:UIControlStateNormal];
        [self p_setupFrame];
    } else {
        /**
         *  其他情况直接隐藏
         */
        self.hidden = YES;
    }
}

- (void)p_setupFrame {
    // 根据文字的多少动态计算frame
    //FIXME: fix some bug make app run quickly
    // 解决的大量计算带来的卡顿问题
    if (self.badgeValue < 10) {
        self.frame = CGRectMake(5, 5, 20, 20);
    } else if (self.badgeValue < 100) {
        self.frame = CGRectMake(5, 5, 28, 20);
    } else {
        self.frame = CGRectMake(5, 5, 32, 20);
    }
    
    //    NSDictionary *attrs = @{NSFontAttributeName : self.titleLabel.font};
    //    CGSize textSize =[self.titleLabel.text boundingRectWithSize:CGSizeMake(300, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    //    CGRect frame = CGRectMake(5, 5, textSize.width, textSize.height);
    //    CGFloat badgeH = 20;
    //    CGFloat length = 0.6;
    //    NSInteger temp = _badgeValue;
    //    if (temp == maxBadgeValue) {
    //        temp++;
    //    }
    //    while (temp) {
    //        length += 0.4;
    //        temp /= 10;
    //    }
    //    frame.size.height = badgeH;
    //    frame.size.width = length * badgeH;
    //    self.frame = frame;
}

@end
