//
//  XXBMediaDataSource.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaDataSource.h"
#import "XXBMediaPHDataSource.h"
#import "XXBMediaALDataSource.h"

@implementation XXBMediaDataSource

static id _instance = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

+ (instancetype)sharedMediaDataSouce {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super alloc] init];
    });
    return _instance;
}

- (id<XXBMediaDataSource>)dataSouce {
    if ([[UIDevice currentDevice] systemVersion].floatValue < 8.0) {
        /**
         *  ios8一下暂时没有支持
         */
        return [XXBMediaALDataSource sharedXXBMediaALDataSource];
    } else {
        return [XXBMediaPHDataSource sharedXXBMediaPHDataSource];
    }
}
@end
