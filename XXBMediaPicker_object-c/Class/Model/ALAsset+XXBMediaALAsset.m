//
//  ALAsset+XXBMediaALAsset.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/5/27.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "ALAsset+XXBMediaALAsset.h"

@implementation ALAsset (XXBMediaPHAsset)

- (UIImage *)placehoderImage {
    return [UIImage imageWithCGImage:self.thumbnail];
}

- (XXBMediaRequestID)imageWithSize:(CGSize)size completionHandler:(XXBMediaImageBlock)completionHandler {
    completionHandler([UIImage imageWithCGImage:self.thumbnail],nil);
    return  (int32_t)[[NSDate date] timeIntervalSince1970];
}


- (void)cancelImageRequest:(XXBMediaRequestID)requestID {
    return;
}

- (XXBMediaType)mediaAssetType {
    if ([[self valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
        //照片
        return XXBMediaTypeImage;
    } else if ([[self valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
        //视频
        return XXBMediaTypeVideo;
    } else {
        //未知
        return XXBMediaTypeUnknown;
    }
}

- (double )mediaAssetTime {
    return [[self valueForProperty:ALAssetPropertyDuration] doubleValue];
}

- (NSString *)identifier {
    return @"";
}
@end
