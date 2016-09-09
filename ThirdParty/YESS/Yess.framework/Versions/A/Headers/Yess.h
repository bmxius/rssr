//
//  Yess.h
//  Yess
//
//  Created by Stig on 28.12.15.
//  Copyright © 2015 YESS. All rights reserved.
//

// Version 1.07

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIView+Frame.h"
#import "Utils.h"
#import "Reachability.h"
#import "SSKeychain.h"
#import "UIImage+ImageEffects.h"
#import "AFViewShaker.h"
#import "NVDate.h"
#import "NSDate+Extension.h"
#import "UIView+Toast.h"
#import "images.h"
#import "ImageSaver.h"

#if TARGET_OS_TV

#else
#import "HDNotificationView.h"
#import "JDStatusBarNotification.h"
#import "NotificationView.h"
#import "camera.h"
#endif

#define kAppEmailSupport @"app@ye-ss.com"

#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kUserDefaultsSynchronize [[NSUserDefaults standardUserDefaults] synchronize]

#define kPostNotification(notificationName)  [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil]
#define kPostNotif(notif,params) [[NSNotificationCenter defaultCenter] postNotificationName:notif object:params]
#define kDefaultCenter [NSNotificationCenter defaultCenter]

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define iOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define kAnimateVelocity 5.0
#define kAnimateDamping 0.8
#define kAnimateTime 0.3

#define kAnimationsOption UIViewAnimationOptionCurveEaseOut
#define kButtonAction UIControlEventTouchUpInside
#define kControlState UIControlStateNormal

@interface Yess : NSObject


+ (Yess*)shared;


@end
