//
//  ASCNewsCell.m
//  ASCTableView
//
//  Created by wenlonggao on 14-4-2.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import "ASCNewsCell.h"
#import "ASCZhihuNews.h"
#import "ASCZhihuNewsManager.h"

#define CellHeight 80.0
#define CellWidth 320.0


@interface ASCNewsCell ()

@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UILabel *title;

@end

@implementation ASCNewsCell

@synthesize image;
@synthesize title;

@synthesize news;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBounds:CGRectMake(0, 0, CellWidth, CellWidth)];
        
        self.image = [[UIImageView alloc] init];
        [self.image setFrame:CGRectMake(15.0, 15.0, CellHeight-30.0, CellHeight-30.0)];
        [self addSubview:self.image];
        
        self.title = [[UILabel alloc] init];
        [self.title setFrame:CGRectMake(90.0, 10.f, CellWidth-100.0, CellHeight-30.0)];
        self.title.numberOfLines = 3;
        [self addSubview:self.title];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNews:(ASCZhihuNews *)anews
{
    news = anews;
    [ASCZhihuNewsManager drawImageWithUrl:self.news.imageUrl inView:self.image];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.news.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [self.title setAttributedText:attributedString];
}



@end
