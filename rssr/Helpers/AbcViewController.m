
//  AbcViewController.m
//  Abc
//
//  Created by Stig on 07.07.15.
//  Copyright (c) 2015 Evgeniy Stig. All rights reserved.
//

#import "AbcViewController.h"

@interface UIViewController (AppUIViewController)
{

}


@end


@implementation UIViewController (AppUIViewController)

-(void)showToast:(NSString*)toastText {
 
    [self.view makeToast:toastText duration:2 position:CSToastPositionBottom];
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popVCWithAnimation{
    [self popViewControllerWithTransition];
}

- (void)popViewControllerWithTransition{
    
    [self addAnimationTransition];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)pushViewControllerWithTransition:(NSString*)controller{
    
    [self addAnimationTransition];
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:controller] animated:NO];
}

- (void)pushViewControllerFrameWithTransition:(id)controller{

    [self addAnimationTransition];
    [self.navigationController pushViewController:(UIViewController*)controller animated:NO];
}

- (void)addAnimationTransition{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

- (id)loadController:(Class)classType {
    NSString *className = NSStringFromClass(classType);
    UIViewController *controller = [[classType alloc] initWithNibName:className bundle:nil];
    return controller;
}

@end
