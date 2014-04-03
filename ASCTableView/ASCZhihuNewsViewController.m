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

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *context;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation ASCZhihuNewsViewController

@synthesize news;

-(void)setNews:(ASCZhihuNews *)anews
{
    news = anews;
    self.title.text = anews.title;
    [ASCZhihuNewsManager drawImageWithUrl:anews.imageUrl complete:^(UIImage *aimage) {
        self.image.image = aimage;
    }];
    [ASCZhihuNewsManager fetchNewsWithUrl:anews.contextUrl complete:^(NSString *acontext) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[acontext dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.context.attributedText = attributedString;
        
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
