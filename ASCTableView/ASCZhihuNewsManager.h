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
+(id)fetchLastNewsMap;
+(void)fetchNewsWithUrl:(NSString*)url complete:(void (^)(id))block;

+(void)drawImageWithUrl:(NSString*)url complete:(void (^)(id))block;

@end
