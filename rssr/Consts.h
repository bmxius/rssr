//
//  Consts.h
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#ifndef Consts_h
#define Consts_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <Yess/Yess.h>
#import <Yess/SVProgressHUD.h>

#import "MWFeedParser.h"
#import <DFImageManager/DFImageManagerKit.h>
#import <KVNProgress/KVNProgress.h>
#import "PBWebViewController.h"


#define     kColorOrangeNav         [UIColor colorWithRed:1 green:0.60224184 blue:0 alpha:1];
#define     kColorLight             [UIColor colorWithRed:1 green:0.98541290 blue:0.92830650 alpha:1];
#define     kColorSeparator         [UIColor colorWithRed:0.88788796 green:0.8878879 blue:0.887887967 alpha:1];
#define     kColorOrangeList        [UIColor colorWithRed:0.91254783 green:0.5495744 blue:0 alpha:1];
#define     kColorTextSecond        [UIColor colorWithRed:0.74240008 green:0.7424000 blue:0.742400085 alpha:1];
#define     kColorText              [UIColor colorWithRed:0.10222682 green:0.0973377 blue:0.087280430 alpha:1];

#define BIG_DEVICE ((MIN(SCREEN_WIDTH, SCREEN_HEIGHT))>320?YES:NO)

#define iOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS_10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

#define kPostNotification(notificationName)  [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil]
#define kLocalized(stringToLocale) NSLocalizedStringFromTable(stringToLocale, @"Localizable", nil)
#define kStandartDefaults [NSUserDefaults standardUserDefaults]
#define kStandartDefaultsSyncronize [[NSUserDefaults standardUserDefaults] synchronize]

#define kAppMarginLeft      12
#define kAppMargin          16

#define kFontSize (BIG_DEVICE?15:14)



#endif
