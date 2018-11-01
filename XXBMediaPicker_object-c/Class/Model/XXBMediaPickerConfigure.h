//
//  XXBMediaPickerConfigure.h
//  XXBMediaPicker
//
//  Created by xiaobing5 on 2018/10/30.
//  Copyright © 2018 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBMediaPickerConfigure : NSObject

/**
 最大选中个数
 */
@property(nonatomic, assign) NSInteger  maxSelectCount;

/**
 是否允许显示角标
 */
@property(nonatomic, assign) BOOL       enableBageValue;

/**
 记录上次选中的相册
 */
@property(nonatomic, assign) BOOL       rememberLastSelectGroup;

/**
 是否允许选中原始照片
 */
@property(nonatomic, assign) BOOL       enableSelectOriginalPic;

/**
 选中照片加载资源，默认是YES，如果自己设置的话需要外边自己读取资源
 */
@property(nonatomic, assign) BOOL       loadMediaOnSelect;

/**
 是否允许选中不同的分组中的照片
 */
@property(nonatomic, assign) NSInteger  enableSelectDifferentOnGroup;

/**
 是否允许预览
 */
@property(nonatomic, assign) BOOL       enablePreview;

/**
 预览的时候是否允许选中
 */
@property(nonatomic, assign) BOOL       enableSelectOnPreview;

/**
 是否允许编辑 （允许编辑的情况下 最大选中个数是1，默认不显示右上角的按钮）
 */
@property(nonatomic, assign) BOOL       enableEdit;

@end
