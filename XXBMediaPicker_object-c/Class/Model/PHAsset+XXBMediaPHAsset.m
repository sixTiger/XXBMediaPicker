//
//  NSObject+XXBMediaPHAsset.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/4.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "PHAsset+XXBMediaPHAsset.h"
#import "XXBMediaPHDataSouce.h"

@implementation PHAsset (XXBMediaPHAsset)

- (XXBMediaRequestID)imageWithSize:(CGSize)size completionHandler:(XXBMediaImageBlock)completionHandler
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize realSize = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale));
    options.synchronous = NO;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.networkAccessAllowed = YES;
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
                                                                    completionHandler(result, nil);
                                                                }
                                                            }];
    
}

- (void)cancelImageRequest:(XXBMediaRequestID)requestID
{
    
}

- (XXBMediaType)assetType
{
    return XXBMediaTypeAudio;
}

- (NSString *)identifier
{
    return self.localIdentifier;
}
@end