//
//  XXBMediaDataSouce.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/15.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaDataSouce.h"
#import "XXBMediaPHDataSouce.h"
#import "XXBMediaALDataSouce.h"

@implementation XXBMediaDataSouce

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

- (id<XXBMediaDataSouce>)dataSouce {

#warning  调试阶段暂时只支持ALasset
    return [XXBMediaALDataSouce sharedXXBMediaALDataSouce];
//    if ([[UIDevice currentDevice] systemVersion].floatValue < 8.0) {
//        /**
//         *  ios8一下暂时没有支持
//         */
//        return [XXBMediaALDataSouce sharedXXBMediaALDataSouce];
//    } else {
//        return [XXBMediaPHDataSouce sharedXXBMediaPHDataSouce];
//    }
}
@end
