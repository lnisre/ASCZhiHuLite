//
//  ASCZhihu.m
//  ASCTableView
//
//  Created by wenlonggao on 14-4-2.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import "ASCZhihu.h"

#define kDate @"date"
#define kNews @"news"
#define kIsToday @"is_today"
#define kTopStories @"top_stories"
#define kDisplayDate @"display_date"

@implementation ASCZhihu

@synthesize date;
@synthesize displayDate;
@synthesize isToday;
@synthesize news;
@synthesize topStories;

+(ASCZhihu *)ASCZhihuWithObject:(id)object
{
    ASCZhihu * result = [[ASCZhihu alloc] init];
    result.date = [object objectForKey:kDate];
    result.isToday = [[object objectForKey:kIsToday] boolValue];
    result.topStories = [object objectForKey:kTopStories];
    result.displayDate = [object objectForKey:kDisplayDate];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id new in [object objectForKey:kNews]) {
        [array addObject:[ASCZhihuNews ASCZhihuNewWithObject:new]];
    }
    result.news = [array copy];
    return result;
}

@end
