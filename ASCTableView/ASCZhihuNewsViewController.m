//
//  ASCZhihuNewsViewController.m
//  ASCTableView
//
//  Created by wenlonggao on 14-4-3.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import "ASCZhihuNewsViewController.h"
#import "ASCZhihuNewsManager.h"
#import "ASCZhihuNews.h"

@interface ASCZhihuNewsViewController ()

@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UITextView *context;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ASCZhihuNewsViewController

@synthesize image;
@synthesize context;
@synthesize news;
@synthesize scrollView;

-(void)setNews:(ASCZhihuNews *)anews
{
    news = anews;

    [ASCZhihuNewsManager drawImageWithUrl:anews.imageUrl complete:^(UIImage *aimage) {
        [self.image setImage:aimage];
        self.scrollView.contentSize = CGSizeMake(320, self.image.bounds.size.height + self.context.bounds.size.height);

    }];
    [ASCZhihuNewsManager fetchNewsWithUrl:anews.contextUrl complete:^(NSString *acontext) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[acontext dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.context.attributedText = attributedString;

        self.context.frame = CGRectMake(self.context.frame.origin.x, self.context.frame.origin.y,
                                         320, [attributedString size].height);
        self.scrollView.contentSize = CGSizeMake(320, self.image.bounds.size.height + self.context.bounds.size.height);

    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        self.image.clipsToBounds = YES;
        [self.scrollView addSubview:self.image];
        self.context = [[UITextView alloc] initWithFrame:CGRectMake(0, 170, 320, 400)];
        [self.context setScrollEnabled:NO];
        [self.scrollView addSubview:self.context];
        
        [self.view addSubview:self.scrollView];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
