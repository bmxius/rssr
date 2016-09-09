//
//  NotificationView.h
//  AudioPrayer
//
//  Copyright (c) 2014 Apps Ministry LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationView : UIView

+(NotificationView*) initNotificationViewWithText:(NSString*)text andMaxWidth:(CGFloat)width;
-(void) showInView:(UIView*)view;

@end
