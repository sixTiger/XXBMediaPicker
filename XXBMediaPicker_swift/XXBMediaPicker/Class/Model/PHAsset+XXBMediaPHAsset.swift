//
//  PHAsset+XXBMediaPHAsset.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/9.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import Photos

extension  PHAsset: XXBMediaAssetDataSouce {
    
    public func imageWithSize(size: CGSize, completionHandler: (UIImage?, [NSObject : AnyObject]?) -> Void) -> XXBMediaRequestID {
        let option = PHImageRequestOptions()
        let scale = UIScreen.mainScreen().scale
        let realSize =  CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale))
        option.synchronous = false
        option.deliveryMode = PHImageRequestOptionsDeliveryMode.Opportunistic
        option.networkAccessAllowed = true
        return XXBDataSouce.sharedImageManager.requestImageForAsset(self, targetSize: realSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: completionHandler)
    }
}
