//
//  NSObject+XXBMediaPHAsset.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/4.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "PHAsset+XXBMediaPHAsset.h"
#import "XXBMediaPHDataSource.h"
#import <objc/runtime.h>

@interface PHAsset()

@end

@implementation PHAsset (XXBMediaPHAsset)

- (UIImage *)placehoderImage {
    return objc_getAssociatedObject(self,@selector(placehoderImage));
}

- (XXBMediaRequestID)imageWithSize:(CGSize)size completionHandler:(XXBMediaImageBlock)completionHandler {
    if (self.placehoderImage != nil) {
        completionHandler(self.placehoderImage,nil);
        return 0;
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize realSize = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale));
    options.synchronous = NO;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.networkAccessAllowed = YES;
    return [[XXBMediaPHDataSource sharedImageManager] requestImageForAsset:self
                                                               targetSize:realSize
                                                              contentMode:PHImageContentModeAspectFill
                                                                  options:options
                                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                NSError *error = info[PHImageErrorKey];
                                                                if (error){
                                                                    if (completionHandler){
                                                                        completionHandler(nil, error);
                                                                    }
                                                                    return;
                                                                }
                                                                if (completionHandler) {
                                                                    completionHandler(result, nil);
                                                                }
                                                            }];
    
}

- (void)cancelImageRequest:(XXBMediaRequestID)requestID {
    [[XXBMediaPHDataSource sharedImageManager] cancelImageRequest:requestID];
}

- (XXBMediaType)mediaAssetType {
    XXBMediaType type = XXBMediaTypeUnknown;
    switch (self.mediaType) {
        case PHAssetMediaTypeUnknown:
        {
            type = XXBMediaTypeUnknown;
            break;
        }
        case PHAssetMediaTypeImage:
        {
            type = XXBMediaTypeImage;
            break;
        }
        case PHAssetMediaTypeVideo:
        {
            type = XXBMediaTypeVideo;
            break;
        }
        case PHAssetMediaTypeAudio:
        {
            type = XXBMediaTypeAudio;
            break;
        }
        default:
            break;
    }
    
    if (self.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
        type = XXBMediaTypeLivePhoto;
    }
    return type;
}

- (double )mediaAssetTime {
    return self.duration;
}

- (NSString *)identifier {
    return self.localIdentifier;
}

@end
