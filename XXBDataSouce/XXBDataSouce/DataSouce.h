//
//  DataSouce.h
//  XXBDataSouce
//
//  Created by xiaobing on 16/1/22.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataSouce <NSObject>

- (NSInteger)numberOfDateSouce;
@end

@protocol DataDelegate <NSObject>

- (NSInteger)numberOfDateDelegate;
@end
