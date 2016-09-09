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
#import "RSRItemTableCell.h"

@interface RSRMainVC () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL _selectedListFav;
    NSArray *_listItems;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControlList;
@property (strong, nonatomic) IBOutlet UIButton *buttonAdd;
@property (strong, nonatomic) IBOutlet UIButton *buttonList;
@property (strong, nonatomic) IBOutlet UITableView *tableViewList;

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
    
    self.tableViewList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableViewList registerNib:[UINib nibWithNibName:@"RSRItemTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemTableCell"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _listItems = [ListItem MR_findAll];
    [self.tableViewList reloadData];
}

#pragma UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ItemTableCell";
    RSRItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    ListItem *item = _listItems[indexPath.section];
    cell.itemFeed = [FeedItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"mainURL == %@",item.url]][indexPath.row];
    
    return cell;
}

- (void)openViewListEdit{
    
    [self pushViewControllerWithTransition:@"viewListEdit"];
}

- (void)openViewAddItem{
    
    [self pushViewControllerWithTransition:@"viewListItemAdd"];
}

@end





