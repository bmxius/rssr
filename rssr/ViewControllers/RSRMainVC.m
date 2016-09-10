//
//  RSRMainVC.m
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import "RSRMainVC.h"
#import "Consts.h"
#import "ListItem+CoreDataProperties.h"
#import "FeedItem+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>
#import "RSRFeedItemTableCell.h"


#warning Want faster?               change
#define kWantFastRender              NO


@interface RSRMainVC () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL _selectedListFav;
    NSArray *_listItems;
    NSMutableDictionary *_fetchedResultsControllers;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControlList;
@property (strong, nonatomic) IBOutlet UIButton *buttonAdd;
@property (strong, nonatomic) IBOutlet UIButton *buttonList;
@property (strong, nonatomic) IBOutlet UITableView *tableViewList;
@property (strong, nonatomic) IBOutlet UILabel *labelCenter;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) PBWebViewController *webViewController;

@end


@implementation RSRMainVC

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    _fetchedResultsControllers = [NSMutableDictionary new];
    
    [self.buttonList addTarget:self action:@selector(openViewListEdit) forControlEvents:kButtonAction];
    [self.buttonAdd addTarget:self action:@selector(openViewAddItem) forControlEvents:kButtonAction];
    
    [self.segmentControlList setTitle:kLocalized(@"ALL") forSegmentAtIndex:0];
    [self.segmentControlList setTitle:kLocalized(@"FAVORITES") forSegmentAtIndex:1];
    
    self.labelCenter.text = kLocalized(@"EMPTY_LIST");
    
    self.tableViewList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableViewList registerNib:[UINib nibWithNibName:@"RSRFeedItemTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemTableCell"];
    
    [self.segmentControlList addTarget:self action:@selector(selectorSegment:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (self.webViewController) {
        self.webViewController = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(onApperView) withObject:nil afterDelay:0.1];
}

- (void)onApperView{

    [self selectorSegment:nil];
}

- (IBAction)selectorSegment:(UISegmentedControl*)sender{
    
   // NSDate *methodStart = [NSDate date];
   
    self.segmentControlList.userInteractionEnabled = NO;
    
    _fetchedResultsControllers = [NSMutableDictionary new];
    if (self.segmentControlList.selectedSegmentIndex == 0) {
        _listItems = [ListItem MR_findAllSortedBy:@"dateAdded" ascending:NO];
    } else {
        _listItems = [ListItem MR_findAllSortedBy:@"dateAdded" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"isFavorite == %@",@1]];
    }
    
//    NSDate *methodFinish = [NSDate date];
//    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//    NSLog(@"executionTime1 = %f", executionTime);
    
    if (sender) {
        [self.tableViewList setContentOffset:CGPointZero animated:NO];
    }
    [self.tableViewList reloadData];
    
    self.segmentControlList.userInteractionEnabled = YES;
    
//    NSDate *methodFinish2 = [NSDate date];
//    NSTimeInterval executionTime2 = [methodFinish2 timeIntervalSinceDate:methodStart];
//    NSLog(@"executionTime2 = %f", executionTime2);
}

- (NSFetchedResultsController *)fetchedResultsControllerForListItem:(ListItem*)listItem {
   
    // NSDate *methodStart = [NSDate date];
    
    if ([self fetchedResultsControllerExistingForListItem:listItem]) {
        return [self fetchedResultsControllerExistingForListItem:listItem];
    }
    
    [_fetchedResultsControllers setObject:[FeedItem MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"mainURL == %@",listItem.url] sortedBy:@"dateAdded" ascending:NO] forKey:listItem.url];
   
//    NSDate *methodFinish = [NSDate date];
//    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//    NSLog(@"executionTime3 = %f", executionTime);
    
    return [self fetchedResultsControllerExistingForListItem:listItem];
}

- (NSFetchedResultsController *)fetchedResultsControllerExistingForListItem:(ListItem*)listItem{
    
    if (_fetchedResultsControllers.allKeys.count && _fetchedResultsControllers[listItem.url]) {
        return _fetchedResultsControllers[listItem.url];
    } else {
        return nil;
    }
}

#pragma UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    self.labelCenter.hidden = _listItems.count;
    return _listItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[[self fetchedResultsControllerForListItem:_listItems[section]] fetchedObjects] count];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ListItem *item = _listItems[section];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    titleLab.backgroundColor = kColorOrangeList;
    titleLab.text = [NSString stringWithFormat:@"   %@",item.name];
    titleLab.textColor = kColorLight;
    titleLab.font = [UIFont systemFontOfSize:15];
    
    return titleLab;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     return [self basicCellAtIndexPath:indexPath];
}

- (RSRFeedItemTableCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    RSRFeedItemTableCell *cell = [self.tableViewList dequeueReusableCellWithIdentifier:@"ItemTableCell" forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (kWantFastRender) {
        return 100;
    }
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static RSRFeedItemTableCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableViewList dequeueReusableCellWithIdentifier:@"ItemTableCell"];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(RSRFeedItemTableCell *)sizingCell {
    
    //[sizingCell setNeedsLayout];
    //[sizingCell layoutIfNeeded];

    if (sizingCell.labelDetail && sizingCell.labelDetail.text.length) {
        float hei = 100 + sizingCell.labelDetail.frame.size.height + kAppMargin;
        return hei < 117 ? 100 : hei;
    } else {
        return 100;
    }
}

- (void)configureBasicCell:(RSRFeedItemTableCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    if (cell.labelDetail && cell.labelDetail.text.length) {
        cell.labelDetail.text = @"";
    }
    
    cell.itemFeed = [[self fetchedResultsControllerForListItem:_listItems[indexPath.section]] fetchedObjects][indexPath.row];
    
    if (kWantFastRender) {
        return;
    }
    
    if (cell.itemFeed.summary) {
        
        if (!cell.labelDetail) {
            cell.labelDetail = [[UILabel alloc] init];
            cell.labelDetail.frame = CGRectMake(12, 100, SCREEN_MIN_LENGTH-kAppMargin*2, 18);
            cell.labelDetail.numberOfLines = 0;
            cell.labelDetail.textColor = kColorText;
            cell.labelDetail.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:cell.labelDetail];
        }
        
        cell.labelDetail.frame = CGRectMake(12, 100, SCREEN_MIN_LENGTH-kAppMargin*2, 18);
        cell.labelDetail.text = [NSString stringWithFormat:@"%@",cell.itemFeed.summary];
        [cell.contentView addSubview:cell.labelDetail];
        [cell.labelDetail sizeToFit];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![Utils isOnline]) {
        [self showToast:kLocalized(@"NO_INTERNET")];
        return;
    }
    
    ListItem *item = _listItems[indexPath.section];
  
    FeedItem *feedItem = [[self fetchedResultsControllerForListItem:item] fetchedObjects][indexPath.row];
    
    NSString *urlStr = nil;
    if (feedItem.link) {
        urlStr = feedItem.link;
    } else if ([feedItem.identifier isKindOfClass:[NSString class]]){
        NSURL *url = [NSURL URLWithString:feedItem.identifier];
        if (url && url.scheme && url.host)
        {
            urlStr = feedItem.identifier;
        }
    }
    
    if (urlStr) {
        self.webViewController = [[PBWebViewController alloc] init];
        self.webViewController.URL = [NSURL URLWithString:urlStr];
        self.webViewController.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self pushViewControllerFrameWithTransition:self.webViewController];
    } else {
        [self showToast:kLocalized(@"ERROR")];
    }
}

- (void)openViewListEdit{
    
    [self pushViewControllerWithTransition:@"viewListEdit"];
}

- (void)openViewAddItem{
    
    [self pushViewControllerWithTransition:@"viewListItemAdd"];
}

@end





