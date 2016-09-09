//
//  AbcViewController.h
//  Abc
//
//  Created by Stig on 07.07.15.
//  Copyright (c) 2015 Evgeniy Stig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Consts.h"

@interface UIViewController (AbcViewController)
{
    
}

- (void)showToast:(NSString*)toastText;

- (void)popVC;
- (void)popVCWithAnimation;
- (void)popViewControllerWithTransition;
- (void)pushViewControllerWithTransition:(NSString*)controller;
- (void)pushViewControllerFrameWithTransition:(id)controller;

- (void)addAnimationTransition;
- (id)loadController:(Class)classType;

@end
