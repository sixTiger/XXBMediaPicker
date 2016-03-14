//
//  XXBMediaAssetDataSouce.swift
//  XXBMediaPicker
//
//  Created by xiaobing on 16/3/9.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

import UIKit


public enum XXBMediaType : NSInteger {
    
    // PHAssetCollectionTypeAlbum regular subtypes
    case Unknown
    case Image
    case Video
    case Audio
    case LivePhoto
}
public typealias XXBMediaRequestID = Int32
public protocol XXBMediaAssetDataSouce : NSObjectProtocol {
    func imageWithSize(size: CGSize, completionHandler: (UIImage?, [NSObject : AnyObject]?) -> Void) -> XXBMediaRequestID
}

