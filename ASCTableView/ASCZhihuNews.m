//
//  ASCZhihuNews.m
//  ASCTableView
//
//  Created by wenlonggao on 14-4-2.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import "ASCZhihuNews.h"

#define kUrl @"url"
#define kThumbnail @"thumbnail"
#define kId @"id"
#define kShareUrl @"share_url"
#define kImage @"image"
#define kGaPrefix @"ga_prefix"
#define kTitle @"title"

@implementation ASCZhihuNews

@synthesize title;
@synthesize imageUrl;
@synthesize shareUrl;
@synthesize contextUrl;
@synthesize thumail;
@synthesize gaPrefix;
@synthesize newId;

+(ASCZhihuNews *)ASCZhihuNewWithObject:(id)object
{
    ASCZhihuNews *result = [[ASCZhihuNews alloc] init];
    result.title = [object objectForKey:kTitle];
    result.imageUrl = [object objectForKey:kImage];
    result.shareUrl = [object objectForKey:kShareUrl];
    result.contextUrl = [object objectForKey:kUrl];
    result.thumail = [object objectForKey:kThumbnail];
    result.gaPrefix = [object objectForKey:kGaPrefix];
    result.newId = [[object objectForKey:kId] longValue];
    
    return result;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:kTitle];
    [aCoder encodeObject:self.imageUrl forKey:kImage];
    [aCoder encodeObject:self.shareUrl forKey:kShareUrl];
    [aCoder encodeObject:contextUrl forKey:kUrl];
    [aCoder encodeObject:self.thumail forKey:kThumbnail];
    [aCoder encodeObject:self.gaPrefix forKey:kGaPrefix];
    [aCoder encodeInteger:self.newId forKey:kId];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:kTitle];
        self.imageUrl = [aDecoder decodeObjectForKey:kImage];
        self.shareUrl = [aDecoder decodeObjectForKey:kShareUrl];
        self.contextUrl = [aDecoder decodeObjectForKey:kUrl];
        self.thumail = [aDecoder decodeObjectForKey:kThumbnail];
        self.gaPrefix = [aDecoder decodeObjectForKey:kGaPrefix];
        self.newId = [aDecoder decodeIntegerForKey:kId];
    }
    return self;
}


@end
