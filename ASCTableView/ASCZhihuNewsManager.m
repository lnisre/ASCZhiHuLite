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
@property (nonatomic, retain) NSString *beforeNewsUrl;
@property (nonatomic, retain) ASCZhihu *newsListings;
@property (nonatomic, retain) NSMutableDictionary *imageDictionary;
@property (nonatomic, retain) NSMutableDictionary *newsDictionary;
@property (nonatomic, retain) NSMutableDictionary *beforeNewsListings;

@property (nonatomic, retain) dispatch_queue_t download;
@end

@implementation ASCZhihuNewsManager
@synthesize lastNewsUrl;
@synthesize newsListings;
@synthesize imageDictionary;
@synthesize newsDictionary;
@synthesize beforeNewsListings;

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
    self.beforeNewsUrl = @"http://news.at.zhihu.com/api/2/news/before/";
}

#pragma mark - synthesize
-(NSMutableDictionary *)imageDictionary
{
    if (imageDictionary == nil) {
        imageDictionary = [[NSMutableDictionary alloc] init];
    }
    return imageDictionary;
}

-(NSMutableDictionary *)newsDictionary
{
    if (newsDictionary == nil) {
        newsDictionary = [[NSMutableDictionary alloc] init];
    }
    return newsDictionary;
}

-(NSMutableDictionary *)beforeNewsListings
{
    if (beforeNewsListings == nil) {
        beforeNewsListings = [[NSMutableDictionary alloc] init];
    }
    return beforeNewsListings;
}

-(dispatch_queue_t)download
{
    if (_download == nil) {
        _download = dispatch_queue_create("downloadNews", NULL);
    }
    return _download;
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

+(id)fetchBeforeNewsMap:(NSString *)date
{
    id result = nil;
    if ([[ASCZhihuNewsManager sharedManager].beforeNewsListings objectForKey:date] == nil) {
        result = [[ASCZhihuNewsManager sharedManager] fetchBeforeNewsMap:date];
        
        [[ASCZhihuNewsManager sharedManager].beforeNewsListings setObject:result forKey:date];
    }else {
        result = [[ASCZhihuNewsManager sharedManager].beforeNewsListings objectForKey:date];
    }
    return result;
}

-(id)fetchBeforeNewsMap:(NSString *)date
{
    id result = nil;
    NSString *string = [NSString stringWithFormat:@"%@%@", self.beforeNewsUrl, date];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([json isKindOfClass:[NSMutableDictionary class]]) {
        result = [ASCZhihu ASCZhihuWithObject:json];
    }
    return result;
}

+(void)fetchNewsWithUrl:(NSString*)url complete:(void (^)(id))block
{
    if ([[ASCZhihuNewsManager sharedManager].newsDictionary objectForKey:url] == nil) {
        [[ASCZhihuNewsManager sharedManager] downloadNewsWithUrl:url complete:block];
    }else {
        block([[ASCZhihuNewsManager sharedManager].newsDictionary objectForKey:url]);
    }
}

-(void)downloadNewsWithUrl:(NSString*)aurl complete:(void (^)(id))block
{
    dispatch_async(self.download, ^{
        
        NSURL *url = [NSURL URLWithString:aurl];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            block(string);
        });
    });
}

#pragma mark - downloadImage

+(void)drawImageWithUrl:(NSString *)url complete:(void (^)(id))block;
{
    if ([[ASCZhihuNewsManager sharedManager].imageDictionary objectForKey:url] == nil) {
        [[ASCZhihuNewsManager sharedManager] downloadImageWithUrl:url complete:block];
    }else {
        block([[ASCZhihuNewsManager sharedManager].imageDictionary objectForKey:url]);
    }
}

-(void)downloadImageWithUrl:(NSString *)aurl complete:(void (^)(UIImage*))block
{
    dispatch_async(self.download, ^{
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
