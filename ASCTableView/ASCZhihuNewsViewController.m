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

@interface ASCZhihuNewsViewController () <UIWebViewDelegate, UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UITextView *context;
@property (retain, nonatomic) IBOutlet UIWebView *webUI;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


@end

@implementation ASCZhihuNewsViewController

@synthesize image;
@synthesize context;
@synthesize news;
@synthesize scrollView;
@synthesize webUI;

-(void)setNews:(ASCZhihuNews *)anews
{
    news = anews;

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:anews.contextUrl]];
    [self.webUI loadRequest:urlRequest];
    
    [ASCZhihuNewsManager drawImageWithUrl:anews.imageUrl complete:^(UIImage *aimage) {
        [self.image setImage:aimage];
        self.scrollView.contentSize = CGSizeMake(320, self.image.bounds.size.height + self.context.bounds.size.height);

    }];
    
    [self.activityIndicatorView startAnimating];
//    [ASCZhihuNewsManager fetchNewsWithUrl:anews.contextUrl complete:^(NSString *acontext) {
//        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[acontext dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        self.context.attributedText = attributedString;
//
//        self.context.frame = CGRectMake(self.context.frame.origin.x, self.context.frame.origin.y,
//                                         320, [attributedString size].height);
//        self.scrollView.contentSize = CGSizeMake(320, self.image.bounds.size.height + self.context.bounds.size.height);
//
//    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        self.scrollView.delegate = self;
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, -100, 320, 270)];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        self.image.clipsToBounds = YES;
        [self.scrollView addSubview:self.image];
//        self.context = [[UITextView alloc] initWithFrame:CGRectMake(0, 170, 320, 400)];
//        [self.context setScrollEnabled:NO];
        
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicatorView.center = CGPointMake(25, 20);
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.scrollView addSubview:self.activityIndicatorView];
        
        self.webUI = [[UIWebView alloc] initWithFrame:CGRectMake(0, 170, 320, 400)];
        self.webUI.scrollView.scrollEnabled = NO;
        self.webUI.delegate = self;
        [self.view addSubview:self.webUI];
        
        [self.scrollView addSubview:self.webUI];
        
        [self.view addSubview:self.scrollView];
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTranslation:)];
        [self.view addGestureRecognizer:recognizer];
        
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

- (void)handleTranslation:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translate = [recognizer translationInView:self.view];
        if (translate.x > 80) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

#pragma mark UIWebView

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    const CGFloat defaultWebViewHeight = 230.0;
    //reset webview size
    CGRect originalFrame = webView.frame;
    webView.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, 320, defaultWebViewHeight);
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    if (actualSize.height <= defaultWebViewHeight) {
        actualSize.height = defaultWebViewHeight;
    }
    CGRect webViewFrame = webView.frame;
    webViewFrame.size.height = actualSize.height;
    webView.frame = webViewFrame;
    
    self.scrollView.contentSize = CGSizeMake(320, self.image.bounds.size.height + self.webUI.bounds.size.height);

    [self.activityIndicatorView stopAnimating];
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)ascrollView willDecelerate:(BOOL)decelerate
{
    if (ascrollView.contentOffset.y <= -100) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.news.contextUrl]];
        [self.webUI loadRequest:urlRequest];
        [self.activityIndicatorView startAnimating];
    }
}

@end
