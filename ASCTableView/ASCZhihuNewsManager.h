//
//  ASCZhihuNewsManager.h
//  ASCTableView
//
//  Created by wenlonggao on 14-4-2.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASCZhihuNewsManager : NSObject

//+(ASCZhihuNewsManager*)sharedManager;
+(id)fetchLastNewsMap;

+(void)drawImageWithUrl:(NSString*)url inView:(id)view;
@end
