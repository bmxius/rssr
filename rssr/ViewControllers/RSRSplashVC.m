//
//  RSRSplashVC.m
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import "RSRSplashVC.h"
#import "Consts.h"

@interface RSRSplashVC ()

@property (strong, nonatomic) IBOutlet UIImageView *imageLogo;
@property (strong, nonatomic) IBOutlet UIView *viewForAnimation;
@property (strong, nonatomic) IBOutlet UILabel *labelStatus;

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
    
    [kDefaultCenter addObserver:self selector:@selector(actionFeedLoaded:) name:kNotificationFeed object:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [Utils sharedUtils];
    [Utils startReachability];
    [RSRAppHelper sharedInstance];
    
    if ([Utils isOnline]) {
        [self loadFeed];
    } else {
        self.labelStatus.text = kLocalized(@"CANT_LOAD");
        [self showToast:kLocalized(@"NO_INTERNET")];
    }
}

- (void)loadFeed{
    
    self.labelStatus.text = kLocalized(@"RSS_DOWNLOAD");
    
    [[RSRAppHelper sharedInstance] loadFeed:NO];
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
