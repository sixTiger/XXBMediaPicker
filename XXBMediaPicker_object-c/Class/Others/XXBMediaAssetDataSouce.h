//
//  XXBMediaAssetDataSouce.h
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/4.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XXBMediaTypeUnknown = 0,
    XXBMediaTypeImage   = 1,
    XXBMediaTypeVideo   = 2,
    XXBMediaTypeAudio   = 3,
} XXBMediaType;

@protocol XXBMediaAssetDataSouce <NSObject>

typedef void (^XXBMediaChangesBlock)();
typedef void (^XXBMediaFailureBlock)(NSError *error);
typedef void (^XXBMediaAddedBlock)(id<XXBMediaAssetDataSouce> media, NSError *error);
typedef void (^XXBMediaImageBlock)(UIImage *result, NSError *error);
typedef int32_t XXBMediaRequestID;


- (XXBMediaRequestID)imageWithSize:(CGSize)size completionHandler:(XXBMediaImageBlock)completionHandler;
- (void)cancelImageRequest:(XXBMediaRequestID)requestID;
- (XXBMediaType)assetType;
- (NSString *)identifier;
@end

@interface XXBMediaAssetDataSouce : NSObject

@end