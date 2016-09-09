//
//  Utils.h
//  YESS
//
//  Copyright (c) Evgeniy Stig All rights reserved.
//

#import "SSKeychain.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define NIB(name) ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? @name "_iPhone" : @name "_iPad")
#define NIB5(name) ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? ([Utils is4InchPhone] ? @name "_iPhone5" : @name "_iPhone") : @name "_iPad")
#define NIBCLASS(name) ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? [name ## _iPhone class] : [name ## _iPad class])

#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IOS_9    SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")

#define STATUS_BAR_HEIGHT   MIN([UIApplication sharedApplication].statusBarFrame.size.height, [UIApplication sharedApplication].statusBarFrame.size.width)
#define STATUS_BAR_COLOR    [UIColor blackColor]

#define NOTIFY_START_ONLINE @"NOTIFY_START_ONLINE"
#define NOTIFY_STOP_ONLINE  @"NOTIFY_STOP_ONLINE"

@interface Utils : NSObject

+(Utils*) sharedUtils;

+(void) showActivity;
+(void) hideActivity;
+(void) startReachability;
+(NSURL*) applicationDocumentsDirectory;
+(NSString*) cacheDirectory;
+(NSString*) libraryDirectory;
+(NSString*) appParamsDirectory;
+(void) createCacheDirectory;
+(void) createNotBackupDirectory;
+(NSString*)notBackupDirectory;
+(NSURL*) databaseDirectory;
+(NSURL*) notBackupDirectoryURL;
+(void) removeCacheContentFile:(NSString*)relativeFile;
+(NSUInteger) cacheContentFileSize:(NSString*)relativeFile;
+(void) applyExcludedFromBackupAttribute:(NSURL*)url;
+(unsigned long long) fileSize:(NSString*)filePath;
+(NSString*) md5:(NSString*)input;
+(NSString*) md5WithData:(NSData*)input;
+(NSString*) sha1:(NSString*)input;
+(NSString*) sha1WithData:(NSData*)input;
+(NSString*) deviceName;
+(NSString*) macAddress;
+(NSString*) userId;
+(BOOL) isOnline;
+(BOOL) isReachableViaWiFi;

+(CGSize) displaySize;
+(BOOL) is4InchPhone;
+(unsigned long long) deviceFreeSpace;
+(NSString *)sign:(NSString*)inputString;
+(BOOL)isRetinaScale;
+(NSString *)getUUID;
+(NSArray*) otherUidList;
+(id) pluralFormForValue:(NSInteger)value withForms:(id)form1, ... NS_REQUIRES_NIL_TERMINATION;

+(void) setHintWasShowedWithID:(NSString*)hintID;
+(BOOL) hintWasShowedWithID:(NSString*)hintID;

+(NSString*) timeFormat:(unsigned long long)value;
+(NSString*) fullTimeFormat:(unsigned long long)value;
+(NSString*) humanReadableFileSize:(unsigned long long)fileSize;
+(NSString*) humanReadableTimeFormat:(unsigned long long)value;

//

+ (void)addBorderToButton:(UIButton*)button;
+ (void)addBorderToButton:(UIButton*)button withColor:(UIColor*)color;

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;
+ (void)showAlertWithTitle:(NSString*)title
                   message:(NSString*)message
           otherButtonText:(NSString*)otherbuttonText
         objectForSelector:(id)objectFor
                    action:(SEL)buttonAction;

+(UIViewController*) currentViewController;

+ (void)sendLocalPush:(NSString *)message;

+ (BOOL)isTheSameDay:(NSDate *)date;
+ (NSInteger)daysSinceDate:(NSDate *)date toDate:(NSDate*)toDate;
+ (NSInteger)yearsSinceDate:(NSDate *)date;
+ (NSInteger)monthsSinceDate:(NSDate *)date;
+ (NSString *)yearsToString:(NSInteger)years;

+ (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color;
+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (void)underlineButton:(UIButton *)btn;

+ (void)showPreloader;
+ (void)showPreloaderWithStatus:(NSString *)status;
+ (void)showPreloaderWithStatus:(NSString *)status progress:(float)progress;
+ (void)hidePreloader;

+ (NSString*)currentLanguage;

@end
