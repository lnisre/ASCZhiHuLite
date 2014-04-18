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
    NSMutableArray *array = [[NSMutableArray alloc] init];
    result.date = [object objectForKey:kDate];
    result.isToday = [[object objectForKey:kIsToday] boolValue];
    result.displayDate = [object objectForKey:kDisplayDate];
//    result.topStories = [object objectForKey:kTopStories];
    for (id topNews in [object objectForKey:kTopStories]) {
        [array addObject:[ASCZhihuNews ASCZhihuNewWithObject:topNews]];
    }
    result.topStories = [array copy];
    
    [array removeAllObjects];
    for (id new in [object objectForKey:kNews]) {
        [array addObject:[ASCZhihuNews ASCZhihuNewWithObject:new]];
    }
    result.news = [array copy];
    return result;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.date forKey:kDate];
    [coder encodeObject:self.displayDate forKey:kDisplayDate];
    [coder encodeBool:self.isToday forKey:kIsToday];
    [coder encodeObject:self.news forKey:kNews];
    [coder encodeObject:self.topStories forKey:kTopStories];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.date = [coder decodeObjectForKey:kDate];
        self.displayDate = [coder decodeObjectForKey:kDisplayDate];
        self.isToday = [coder decodeBoolForKey:kIsToday];
        self.news = [coder decodeObjectForKey:kNews];
        self.topStories = [coder decodeObjectForKey:kTopStories];
    }
    return self;
}


@end
