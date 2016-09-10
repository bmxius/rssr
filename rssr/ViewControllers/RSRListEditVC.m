//
//  RSRListEditVC.m
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import "RSRListEditVC.h"
#import <MagicalRecord/MagicalRecord.h>
#import "ListItem+CoreDataProperties.h"
#import "FeedItem+CoreDataProperties.h"
#import "RSRListItemAddEdit.h"
#import "RSRListItemTableCell.h"
#import "Consts.h"

@interface RSRListEditVC ()
{
     NSArray *_listItems;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewList;
@property (strong, nonatomic) IBOutlet UILabel *labelCenter;
@property (strong, nonatomic) IBOutlet UIButton *buttonAdd;

@end


@implementation RSRListEditVC

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.labelCenter.text = kLocalized(@"EMPTY_LIST");
     [self.buttonAdd addTarget:self action:@selector(openViewAddItem) forControlEvents:kButtonAction];
    
    self.tableViewList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableViewList registerNib:[UINib nibWithNibName:@"RSRListItemTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemTableCell"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _listItems = [ListItem MR_findAllSortedBy:@"dateAdded" ascending:NO];
    [self.tableViewList reloadData];
}

- (IBAction)actionBack:(id)sender {
    [self popVCWithAnimation];
}

#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.labelCenter.hidden = _listItems.count;
    return _listItems.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ItemTableCell";
    RSRListItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    ListItem *item = _listItems[indexPath.row];
    
    cell.itemList = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListItem *item = _listItems[indexPath.row];
    RSRListItemAddEdit *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"viewListItemAdd"];
    controller.itemList = item;
    [self pushViewControllerFrameWithTransition:controller];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    
        [Utils showPreloaderWithStatus:kLocalized(@"PROCESSING")];
        
        ListItem *item = _listItems[indexPath.row];
        
        NSArray *feeds = [FeedItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"mainURL == %@",item.url]];
        for (FeedItem *feed in feeds) {
            [feed MR_deleteEntity];
        }
        
        [item MR_deleteEntity];
        
        [self saveContext];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

-(void)saveContext {
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        
        _listItems = [ListItem MR_findAllSortedBy:@"dateAdded" ascending:NO];
        [self.tableViewList reloadData];
        [Utils hidePreloader];
        if (contextDidSave) {
            
            
        } else if (error) {
            
            
        }
    }];
}

- (void)openViewAddItem{
    
    [self pushViewControllerWithTransition:@"viewListItemAdd"];
}

@end
