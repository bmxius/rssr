//
//  RSRListItemAddEdit.m
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import "RSRListItemAddEdit.h"
#import "Consts.h"
#import <MagicalRecord/MagicalRecord.h>

@interface RSRListItemAddEdit ()
@property (strong, nonatomic) IBOutlet UITextField *fieldURL;
@property (strong, nonatomic) IBOutlet UITextField *fieldName;
@property (strong, nonatomic) IBOutlet UILabel *labelFav;
@property (strong, nonatomic) IBOutlet UISwitch *switchFav;
@property (strong, nonatomic) IBOutlet UIButton *buttonSave;

@end


@implementation RSRListItemAddEdit

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (self.itemList) {
        self.fieldName.text = self.itemList.name;
        self.fieldURL.text = self.itemList.url;
        [self.switchFav setOn:[self.itemList.isFavorite boolValue]];
    }
    
    [self.buttonSave addTarget:self action:@selector(actionSave) forControlEvents:kButtonAction];
    [self.switchFav addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventValueChanged];
    self.labelFav.text = kLocalized(@"IN_FAV");
    self.fieldName.placeholder = kLocalized(@"NAME");
    self.fieldURL.placeholder = kLocalized(@"URL");
    [self.buttonSave setTitle:kLocalized(@"SAVE") forState:kControlState];
}

- (IBAction)actionSwitch:(UISwitch*)sender{
    
}

- (IBAction)actionBack:(id)sender {
    [self popVCWithAnimation];
}

- (void)actionSave{
    
    if (!self.itemList) {
        
        ListItem *existingTitle = [ListItem MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"name == %@",self.fieldName.text]];
        ListItem *existingURL = [ListItem MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"url == %@",self.fieldURL.text]];
        
        if (existingTitle) {
            [self showToast:kLocalized(@"ITEM_WITH_THIS_NAME_EXISTS")];
            return;
        }
        if (existingURL) {
            [self showToast:kLocalized(@"THIS_ITEM_URL_EXISTS")];
            return;
        }
        if (!self.fieldName.text.length) {
            [self showToast:kLocalized(@"TOO_SHORT_NAME")];
            return;
        }
        
        ListItem *aItem = [ListItem MR_createEntity];
        aItem.isFavorite = @(self.switchFav.isOn);
        aItem.url = self.fieldURL.text;
        aItem.name = self.fieldName.text;
        aItem.dateAdded = [NSDate date];
        
    } else {
        
        self.itemList.isFavorite = @(self.switchFav.isOn);
        self.itemList.url = self.fieldURL.text;
        self.itemList.name = self.fieldName.text;
    }
    
    [self saveContext];
}

-(void)saveContext {
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
            
            [self showToast:kLocalized(@"DONE")];
            [[RSRAppHelper sharedInstance] loadFeed:YES];
            [self popVCWithAnimation];
            
        } else if (error) {
            
            [self showToast:kLocalized(@"ERROR")];
        }
    }];
}


@end
