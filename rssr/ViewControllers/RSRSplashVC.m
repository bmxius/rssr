//
//  RSRSplashVC.m
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import "RSRSplashVC.h"
#import "Consts.h"
#import "FeedItem+CoreDataProperties.h"

@interface RSRSplashVC ()

@property (strong, nonatomic) IBOutlet UIImageView *imageLogo;
@property (strong, nonatomic) IBOutlet UIView *viewForAnimation;
@property (strong, nonatomic) IBOutlet UILabel *labelStatus;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLoading;

@end


@implementation RSRSplashVC

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelStatus.text = @"";
    self.viewForAnimation.frame = CGRectMake(0, SCREEN_MAX_LENGTH, SCREEN_MIN_LENGTH, 1);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [kDefaultCenter addObserver:self selector:@selector(actionFeedLoaded:) name:kNotificationFeed object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [Utils sharedUtils];
    [Utils startReachability];
    [RSRAppHelper sharedInstance];
    
    if ([Utils isOnline]) {
        [self loadFeed];
    } else {
        [self openCachedQuestion];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [kDefaultCenter removeObserver:self name:kNotificationFeed object:nil];
}

- (void)openCachedQuestion{
    
    [self.indicatorLoading stopAnimating];
    self.labelStatus.text = kLocalized(@"CANT_LOAD");
    
    if ([FeedItem MR_findAll].count) {
        
        UIAlertController *selectorAlert = [UIAlertController alertControllerWithTitle:kLocalized(@"CANT_LOAD_OPEN_SAVED") message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [selectorAlert addAction:[UIAlertAction actionWithTitle:kLocalized(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openCachedFeeds];
        }]];
        [selectorAlert addAction:[UIAlertAction actionWithTitle:[kLocalized(@"CANCEL") capitalizedString] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:selectorAlert animated:YES completion:^{
            
        }];
    } else {
        [self showToast:kLocalized(@"NO_INTERNET")];
    }
}

- (void)openCachedFeeds{
    
    [self openMainVC];
}

- (void)loadFeed{
    
    [self.indicatorLoading startAnimating];
    
    self.labelStatus.text = kLocalized(@"RSS_DOWNLOAD");
    
    [[RSRAppHelper sharedInstance] loadNewFeed:NO];
}

- (void)actionFeedLoaded:(NSNotification*)notification{
    
    if (notification.object && [notification.object boolValue]) {
        [self showToast:@"LOADED_WITH_ERRORS"];
    }
    [self openMainVC];
}

- (void)openMainVC{
    
    [UIView animateWithDuration:kAnimateTime animations:^{
        
        self.imageLogo.alpha = 0;
        self.viewForAnimation.frame = CGRectMake(0, 64, SCREEN_MIN_LENGTH, SCREEN_MAX_LENGTH);
        
    } completion:^(BOOL finished) {
       
        [self pushViewControllerWithTransition:@"viewMain"];
    }];
}

@end
