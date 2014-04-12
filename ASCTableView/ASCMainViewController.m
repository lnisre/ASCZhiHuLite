//
//  ASCMainViewController.m
//  ASCTableView
//
//  Created by wenlonggao on 14-4-11.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import "ASCMainViewController.h"
#import "ASCNewsListingsViewController.h"
#import "ASCZhihuNewsManager.h"
#import "ASCZhihu.h"
#import "ASCZhihuNews.h"
#import "ASCZhihuNewsViewController.h"

@interface ASCMainViewController () <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet ASCNewsListingsViewController *newsListingViewController;
@property (nonatomic, retain) ASCZhihu *news;
@property (nonatomic, retain) IBOutlet UIPageControl *topNewsPageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *topNewsScrollView;

@end

@implementation ASCMainViewController

@synthesize newsListingViewController;
@synthesize news;
@synthesize topNewsPageControl;
@synthesize topNewsScrollView;

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
    self.news = [ASCZhihuNewsManager fetchLastNewsMap];
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    

    self.topNewsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -100, 320, 300)];
    for (int i = 0; i < self.news.topStories.count; i++) {
        ASCZhihuNews *topNews = self.news.topStories[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, 320, 300)];
        [ASCZhihuNewsManager drawImageWithUrl:topNews.imageUrl complete:^(id image) {
            imageView.image = image;
        }];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnTopNews:)];
        [imageView addGestureRecognizer:g];
        [self.topNewsScrollView addSubview:imageView];
        
        UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(i*320 + 30, 125, 260, 60)];
        topTitle.numberOfLines = 2;
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:topNews.title attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [topTitle setAttributedText:title];
        
        [self.topNewsScrollView addSubview:topTitle];
    }
    self.topNewsScrollView.contentSize = CGSizeMake(320*self.news.topStories.count, 300);
    self.topNewsScrollView.alwaysBounceVertical = NO;
    self.topNewsScrollView.alwaysBounceHorizontal = YES;
    self.topNewsScrollView.pagingEnabled = YES;
    self.topNewsScrollView.showsHorizontalScrollIndicator = NO;
    self.topNewsScrollView.showsVerticalScrollIndicator = NO;
    self.topNewsScrollView.delegate = self;
    [mainScrollView addSubview:self.topNewsScrollView];
    
    self.topNewsPageControl =[[UIPageControl alloc] initWithFrame:CGRectMake(0, 170, 320, 30)];
    self.topNewsPageControl.numberOfPages = self.news.topStories.count;
    self.topNewsPageControl.currentPage = 0;
    [self.topNewsPageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [mainScrollView addSubview:self.topNewsPageControl];
    
    self.newsListingViewController = [[ASCNewsListingsViewController alloc] initWithNibName:nil bundle:nil];
    self.newsListingViewController.tableView.frame = CGRectMake(0, 200, 320, 30 + 80*self.news.news.count);
    self.newsListingViewController.tableView.scrollEnabled = NO;
    [mainScrollView addSubview:self.newsListingViewController.tableView];
    mainScrollView.contentSize = CGSizeMake(320, self.topNewsScrollView.bounds.size.height + self.newsListingViewController.tableView.bounds.size.height);
    
    [self.view addSubview:mainScrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    if (scrollView != self.topNewsScrollView) {
        return ;
    }
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.topNewsPageControl setCurrentPage:offset.x/bounds.size.width];
}

//然后是点击UIPageControl时的响应函数pageTurn


- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = self.topNewsScrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [self.topNewsScrollView scrollRectToVisible:rect animated:YES];
}

- (void)clickOnTopNews:(UITapGestureRecognizer *)recognizer
{
    ASCZhihuNewsViewController *newsViewController = [[ASCZhihuNewsViewController alloc] initWithNibName:nil bundle:nil];
    
    [newsViewController setNews:[self.news.topStories objectAtIndex:self.topNewsPageControl.currentPage]];
    [self.navigationController pushViewController:newsViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
