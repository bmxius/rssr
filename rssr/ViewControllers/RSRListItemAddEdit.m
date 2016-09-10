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
@property (strong, nonatomic) IBOutlet UIButton *buttonKeyboard;

@end


@implementation RSRListItemAddEdit

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self keyboardButtonHide];
    [self.buttonKeyboard addTarget:self action:@selector(actionEndEditing:) forControlEvents:kButtonAction];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [kDefaultCenter addObserver:self selector:@selector(actionFeedLoaded:) name:kNotificationFeed object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [kDefaultCenter removeObserver:self name:kNotificationFeed object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.itemList) {
        [self askPastboard];
    }
}

- (void)askPastboard{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.string.length){
        NSURL *url = [NSURL URLWithString:pasteboard.string];
        if (url && url.scheme && url.host)
        {
            UIAlertController *selectorAlert = [UIAlertController alertControllerWithTitle:kLocalized(@"SHOULD_ADD_THIS_URL") message:pasteboard.string preferredStyle:UIAlertControllerStyleAlert];
            
            [selectorAlert addAction:[UIAlertAction actionWithTitle:kLocalized(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                self.fieldURL.text = pasteboard.string;
            }]];
            [selectorAlert addAction:[UIAlertAction actionWithTitle:[kLocalized(@"CANCEL") capitalizedString] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:selectorAlert animated:YES completion:^{
                
            }];
        }
    }
}

- (void)actionFeedLoaded:(NSNotification*)notification{
    
    [Utils hidePreloader];
    if (notification.object && [notification.object boolValue]) {
        [self showToast:@"LOADED_WITH_ERRORS"];
    }
    [self popVCWithAnimation];
}

- (IBAction)actionSwitch:(UISwitch*)sender{
    
}

- (void)keyboardButtonShow
{
    self.buttonKeyboard.alpha = 1;
}

- (void)keyboardButtonHide
{
    self.buttonKeyboard.alpha = 0;
}

- (IBAction)actionEndEditing:(id)sender
{
    [self.view endEditing:YES];
    [self keyboardButtonHide];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self keyboardButtonShow];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self actionEndEditing:nil];
    return YES;
}

- (IBAction)actionBack:(id)sender {
    [self popVCWithAnimation];
}

- (void)actionSave{
    
    if (![Utils isOnline]) {
        [self showToast:kLocalized(@"NO_INTERNET")];
        return;
    }
    
    ListItem *existingTitle = [[ListItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"name == %@",self.fieldName.text]] firstObject];
    ListItem *existingURL = [[ListItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"url == %@",self.fieldURL.text]] firstObject];
    
    if ((!self.itemList && existingTitle) || (self.itemList && existingTitle && [existingURL.url isEqualToString:self.fieldURL.text])) {
        [self showToast:kLocalized(@"ITEM_WITH_THIS_NAME_EXISTS")];
        return;
    }
    if ((!self.itemList && existingURL) || (self.itemList && existingURL && [existingURL.name isEqualToString:self.fieldName.text])) {
        [self showToast:kLocalized(@"THIS_ITEM_URL_EXISTS")];
        return;
    }
    if (!self.fieldName.text.length) {
        [self showToast:kLocalized(@"TOO_SHORT_NAME")];
        return;
    }
    
    if (!self.itemList) {
        
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
    
    [Utils showPreloaderWithStatus:kLocalized(@"PROCESSING")];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        
        if (contextDidSave) {
            
            [[RSRAppHelper sharedInstance] loadNewFeed:YES];
            
        } else if (error) {
            [Utils hidePreloader];
            [self showToast:kLocalized(@"ERROR")];
        }
    }];
}


@end
