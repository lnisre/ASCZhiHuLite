//
//  ASCZhihu.h
//  ASCTableView
//
//  Created by wenlonggao on 14-4-2.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

//a) JSON串分为如下部分：date-日期，news-当日新闻，is_today-是否为今日，top_stories-界面顶部ViewPager显示内容，display_date-显示的日期

#import <Foundation/Foundation.h>
#import "ASCZhihuNews.h"

@interface ASCZhihu : NSObject

@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) NSArray* news;
@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, retain) NSArray* topStories;
@property (nonatomic, retain) NSString* displayDate;

+(ASCZhihu*)ASCZhihuWithObject:(id)object;

@end
