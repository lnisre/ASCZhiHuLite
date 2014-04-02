//
//  ASCZhihuNews.h
//  ASCTableView
//
//  Created by wenlonggao on 14-4-2.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

//在news中每一个元素中，包括以下属性：image_source-图片版权所有者，title-标题，url-获得离线下载JSON数据的地址（可通过此地址获得对应新闻的JSON内容，通过JSOUP解析body部分获得文章内容），image-图像地址，share_url-在线查看地址，thumbnail-列表中消息的缩略图，ga_prefix-作用未知，id-url（在线查看与离线下载）最后的数字

#import <Foundation/Foundation.h>

@interface ASCZhihuNews : NSObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* contextUrl;
@property (nonatomic, retain) NSString* imageUrl;
@property (nonatomic, retain) NSString* shareUrl;
@property (nonatomic, retain) NSString* thumail;
@property (nonatomic, retain) NSString* gaPrefix;
@property (nonatomic, assign) NSInteger newId;

+(ASCZhihuNews*)ASCZhihuNewWithObject:(id)object;

@end
