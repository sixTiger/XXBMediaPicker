//
//  NSObject+XXBMediaPHAsset.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/4.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "PHAsset+XXBMediaPHAsset.h"
#import "XXBMediaPHDataSouce.h"
#import <objc/runtime.h>

@interface PHAsset()
@property(nonatomic , strong) UIImage   *placehoderImage;
@end

@implementation PHAsset (XXBMediaPHAsset)

- (void)setPlacehoderImage:(UIImage *)placehoderImage {
    [self willChangeValueForKey:@"XXBPlacehoderImage"];
    objc_setAssociatedObject(self, @selector(placehoderImage),
                             placehoderImage,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"XXBPlacehoderImage"];
}

- (UIImage *)placehoderImage {
    return objc_getAssociatedObject(self,@selector(placehoderImage));
}

- (XXBMediaRequestID)imageWithSize:(CGSize)size completionHandler:(XXBMediaImageBlock)completionHandler
{
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
    __weak typeof(self)weakSelf = self;
    return [[XXBMediaPHDataSouce sharedImageManager] requestImageForAsset:self
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
                                                                if (completionHandler){
                                                                    __strong typeof(self)strongSelf = weakSelf;
                                                                    strongSelf.placehoderImage = result;
                                                                    completionHandler(result, nil);
                                                                }
                                                            }];
    
}

- (void)cancelImageRequest:(XXBMediaRequestID)requestID
{
    
}

- (XXBMediaType)mediaAssetType
{
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
    
    if (self.mediaSubtypes & PHAssetMediaSubtypePhotoLive)
    {
        type = XXBMediaTypeLivePhoto;
    }
    return type;
}

- (double )mediaAssetTime
{
    return self.duration;
}

- (NSString *)identifier
{
    return self.localIdentifier;
}

@end
