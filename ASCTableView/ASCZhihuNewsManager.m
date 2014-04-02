//
//  ASCZhihuNewsManager.m
//  ASCTableView
//
//  Created by wenlonggao on 14-4-2.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import "ASCZhihuNewsManager.h"
#import "ASCZhihu.h"

@interface ASCZhihuNewsManager ()

@property (nonatomic, retain) NSString *lastNewsUrl;
@property (nonatomic, retain) ASCZhihu *newsListings;
@property (nonatomic, retain) NSMutableDictionary *imageDictionary;
@end

@implementation ASCZhihuNewsManager
@synthesize lastNewsUrl;
@synthesize newsListings;
@synthesize imageDictionary;

+(ASCZhihuNewsManager *)sharedManager
{
    static ASCZhihuNewsManager* share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        share = [[ASCZhihuNewsManager alloc] init];
        [share setUp];
    });
    return share;
}

-(void)setUp
{
    self.lastNewsUrl = @"http://news-at.zhihu.com/api/2/news/latest";
}

#pragma mark - synthesize
-(NSMutableDictionary *)imageDictionary
{
    if (imageDictionary == nil) {
        imageDictionary = [[NSMutableDictionary alloc] init];
    }
    return imageDictionary;
}

#pragma mark - fetchNews

+(id)fetchLastNewsMap
{
    if ([ASCZhihuNewsManager sharedManager].newsListings == nil) {
        [ASCZhihuNewsManager sharedManager].newsListings = [[ASCZhihuNewsManager sharedManager] fetchLastNewsMap];
    }
    return [ASCZhihuNewsManager sharedManager].newsListings;
}

-(id)fetchLastNewsMap
{
    id result = nil;
    NSURL *url = [NSURL URLWithString:self.lastNewsUrl];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([json isKindOfClass:[NSMutableDictionary class]]) {
        result = [ASCZhihu ASCZhihuWithObject:json];
    }
    return result;
}

#pragma mark - downloadImage

+(void)drawImageWithUrl:(NSString *)url inView:(id)view
{
    if ([[ASCZhihuNewsManager sharedManager].imageDictionary objectForKey:url] == nil) {
        [[ASCZhihuNewsManager sharedManager] downloadImageWithUrl:url complete:^(UIImage *image) {
            if ([view respondsToSelector:@selector(setImage:)]) {
                [view performSelector:@selector(setImage:) withObject:image];
            }
        }];
    }else {
        if ([view respondsToSelector:@selector(setImage:)]) {
            [view performSelector:@selector(setImage:) withObject:
             [[ASCZhihuNewsManager sharedManager].imageDictionary objectForKey:url]];
        }
    }
}

-(void)downloadImageWithUrl:(NSString *)aurl complete:(void (^)(UIImage*))block
{
    dispatch_queue_t download = dispatch_queue_create("downloadImage", NULL);
    dispatch_async(download, ^{
        NSURL *url = [NSURL URLWithString:aurl];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        __block UIImage *image = [UIImage imageWithData:data];
        [self.imageDictionary setObject:image forKey:aurl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(image);
        });
    });
}

@end
