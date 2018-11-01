//
//  XXBMediaLoadingView.h
//  XXBMediaPicker
//
//  Created by xiaobing5 on 2018/11/1.
//  Copyright © 2018 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXBMediaLoadingView : UIView

/**
 * default is YES. calls -setHidden when animating gets set to NO
 */
@property(nonatomic, assign) BOOL hidesWhenStopped;

/**
 startAnimating
 */
- (void)startAnimating;

/**
 stopAnimating
 */
- (void)stopAnimating;
@end
