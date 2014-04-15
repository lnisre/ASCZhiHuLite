//
//  ASCNewsListingsViewController.m
//  ASCTableView
//
//  Created by wenlonggao on 14-4-2.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import "ASCNewsListingsViewController.h"
#import "ASCZhihu.h"
#import "ASCZhihuNewsManager.h"
#import "ASCNewsCell.h"
#import "ASCZhihuNewsViewController.h"

static NSString *CellIdentifier = @"Cell";

@interface ASCNewsListingsViewController ()

@property (nonatomic, retain) ASCZhihu *todayNewsListing;
@property (retain, nonatomic) IBOutlet UIImageView *topNews;
@property (retain, nonatomic) NSMutableArray *beforeNewsListings;
@property (retain, nonatomic) NSDate *loadedDate;

@end

@implementation ASCNewsListingsViewController

@synthesize todayNewsListing;
@synthesize beforeNewsListings;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray *)beforeNewsListings
{
    if (beforeNewsListings == nil) {
        beforeNewsListings = [[NSMutableArray alloc] init];
    }
    return beforeNewsListings;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.todayNewsListing = [ASCZhihuNewsManager fetchLastNewsMap];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMdd"];
    self.loadedDate = [dateFormatter dateFromString:self.todayNewsListing.date];

    self.tableView.rowHeight = 80.0;
    [self.tableView registerClass:[ASCNewsCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSUInteger)loadMoreNews
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *date = [dateFormatter stringFromDate:self.loadedDate];
    if (self.beforeNewsListings.count == 0 || [date isEqualToString:[(ASCZhihu*)[self.beforeNewsListings lastObject] date]]) {
//        NSLog(@"load %@", date);
        id news = [ASCZhihuNewsManager fetchBeforeNewsMap:date];
        [self.beforeNewsListings addObject:news];
        self.loadedDate = [self.loadedDate dateByAddingTimeInterval:-60*60*24];
        [self.tableView reloadData];
        return [[news news] count];
    }
    return 0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.beforeNewsListings.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return self.todayNewsListing.news.count;
    }else {
        return [[[self.beforeNewsListings objectAtIndex:section-1] news] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (indexPath.section == 0) {
        cell.news = [self.todayNewsListing.news objectAtIndex:indexPath.row];
    }else {
        cell.news = [[[self.beforeNewsListings objectAtIndex:indexPath.section-1] news] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    UILabel *title = [[UILabel alloc] initWithFrame:header.frame];

    NSString *date = nil;
    if (section == 0) {
        date = [NSString stringWithFormat:@"   %@", self.todayNewsListing.displayDate];
    }else {
        date = [NSString stringWithFormat:@"   %@", [[self.beforeNewsListings objectAtIndex:section-1] displayDate]];
    }
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:date attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [title setAttributedText:string];
    
    [title setBackgroundColor:[UIColor blueColor]];
    [title setAlpha:0.9];
    [header addSubview:title];
    
    return header;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASCZhihuNewsViewController *newsViewController = [[ASCZhihuNewsViewController alloc] initWithNibName:nil bundle:nil];
    
    [newsViewController setNews:[self.todayNewsListing.news objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:newsViewController animated:YES];
    return indexPath;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation
/*
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}
*/


@end
