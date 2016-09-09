//  ImageSaver.h
//  Ilya Inyushin

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageSaver : NSObject

+ (BOOL)saveImageToDisk:(UIImage*)image;
+ (void)deleteImageAtPath:(NSString*)path;

@end
