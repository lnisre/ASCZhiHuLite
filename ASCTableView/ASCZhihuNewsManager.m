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
@property (nonatomic, retain) ASCZhihu *zhihuLastNews;
@property (nonatomic, retain) NSMutableDictionary *imageDictionary;
@property (nonatomic, retain) NSMutableDictionary *newsDictionary;
@property (nonatomic, retain) NSMutableDictionary *beforeNewsListings;

@property (nonatomic, retain) NSString *lastNewsLocalPath;
@property (nonatomic, retain) NSString *beforeNewsLocalPath;

@property (nonatomic, retain) dispatch_queue_t download;
@end

@implementation ASCZhihuNewsManager
@synthesize lastNewsUrl;
@synthesize zhihuLastNews;
@synthesize imageDictionary;
@synthesize newsDictionary;
@synthesize beforeNewsListings;
@synthesize lastNewsLocalPath;
@synthesize beforeNewsLocalPath;

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
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.lastNewsLocalPath = [docDirectory stringByAppendingString:@"lastNews"];
    self.beforeNewsLocalPath = [docDirectory stringByAppendingString:@"beforeNews"];
    
    zhihuLastNews = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:self.lastNewsLocalPath]];
    beforeNewsListings = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:self.beforeNewsLocalPath]];
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

#pragma mark - KeyedArchiver
-(void)lastNewsKeyedAcrhiver
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.zhihuLastNews];
    [data writeToFile:self.lastNewsLocalPath atomically:YES];
}

-(void)beforeNewsKeyedAcrhiver
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.beforeNewsListings];
    [data writeToFile:self.beforeNewsLocalPath atomically:YES];
}

#pragma mark - fetchNews

+(void)fetchLastNewsMapWithComplete:(void (^)(id))block
{
    [[ASCZhihuNewsManager sharedManager] fetchLastNewsMapWithComplete:^(ASCZhihu* lastNews) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyyMMdd"];
        NSComparisonResult result = [[dateFormatter dateFromString:lastNews.date] compare:[dateFormatter dateFromString:[ASCZhihuNewsManager sharedManager].zhihuLastNews.date]];
        if (result == NSOrderedDescending) {
            [ASCZhihuNewsManager sharedManager].zhihuLastNews = lastNews;
            [[ASCZhihuNewsManager sharedManager] lastNewsKeyedAcrhiver];
            block(lastNews);
            return ;
        }
        if (result == NSOrderedSame && lastNews.news.count > [ASCZhihuNewsManager sharedManager].zhihuLastNews.news.count) {
            [ASCZhihuNewsManager sharedManager].zhihuLastNews = lastNews;
            [[ASCZhihuNewsManager sharedManager] lastNewsKeyedAcrhiver];
            block(lastNews);
            return ;
        }
    }];
}

-(void)fetchLastNewsMapWithComplete:(void (^)(id))block
{
    dispatch_async(self.download, ^{
        id result = nil;
        NSURL *url = [NSURL URLWithString:self.lastNewsUrl];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([json isKindOfClass:[NSMutableDictionary class]]) {
            result = [ASCZhihu ASCZhihuWithObject:json];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            block(result);
        });
    });
}

+(id)fetchLocalLastNewsMap
{
    if ([ASCZhihuNewsManager sharedManager].zhihuLastNews == nil) {
        [ASCZhihuNewsManager sharedManager].zhihuLastNews = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[ASCZhihuNewsManager sharedManager].lastNewsLocalPath]];
    }
    return [ASCZhihuNewsManager sharedManager].zhihuLastNews;
}

+(id)fetchBeforeNewsMap:(NSString *)date
{
    id result = nil;
    if ([[ASCZhihuNewsManager sharedManager].beforeNewsListings objectForKey:date] == nil) {
        result = [[ASCZhihuNewsManager sharedManager] fetchBeforeNewsMap:date];
        
        [[ASCZhihuNewsManager sharedManager].beforeNewsListings setObject:result forKey:date];
        
        [[ASCZhihuNewsManager sharedManager] beforeNewsKeyedAcrhiver];
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
