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

@interface RSRMainVC () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL _selectedListFav;
    NSArray *_listItems;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControlList;
@property (strong, nonatomic) IBOutlet UIButton *buttonAdd;
@property (strong, nonatomic) IBOutlet UIButton *buttonList;
@property (strong, nonatomic) IBOutlet UITableView *tableViewList;
@property (strong, nonatomic) IBOutlet UILabel *labelCenter;

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
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self selectorSegment:self.segmentControlList];
}

- (IBAction)selectorSegment:(UISegmentedControl*)sender{
    
    if (sender.selectedSegmentIndex == 0) {
        _listItems = [ListItem MR_findAll];
    } else {
        _listItems = [ListItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"isFavorite == %@",@1]];
    }
    [self.tableViewList reloadData];
}

#pragma UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    self.labelCenter.hidden = _listItems.count;
    return _listItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ListItem *item = _listItems[section];
    
    NSArray *feeds = [FeedItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"mainURL == %@",item.url]];
    return feeds.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ListItem *item = _listItems[section];
    return item.name;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ItemTableCell";
    RSRFeedItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    ListItem *item = _listItems[indexPath.section];
    cell.itemFeed = [FeedItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"mainURL == %@",item.url]][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListItem *item = _listItems[indexPath.section];
    FeedItem *feedItem = [FeedItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"mainURL == %@",item.url]][indexPath.row];
    
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
        
        // This property also corresponds to the same one on UIActivityViewController
        // Both properties do not need to be set unless you want custom actions
        self.webViewController.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
        
        // Push it
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:self.webViewController animated:YES];
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





