//
//  ASCZhihuNewsManager.h
//  ASCTableView
//
//  Created by wenlonggao on 14-4-2.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASCZhihuNews;

@interface ASCZhihuNewsManager : NSObject

//+(ASCZhihuNewsManager*)sharedManager;
+(void)fetchLastNewsMapWithComplete:(void (^)(id))block;
+(id)fetchLocalLastNewsMap;

+(void)fetchNewsWithUrl:(NSString*)url complete:(void (^)(id))block;

+(void)drawImageWithUrl:(NSString*)url complete:(void (^)(id))block;

+(id)fetchBeforeNewsMap:(NSString *)date;

@end
