//
//  RSRAppHelper.h
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "FeedItem+CoreDataProperties.h"
#import "ListItem+CoreDataProperties.h"
#import <DFImageManager/DFImageManagerKit+UI.h>

@interface RSRAppHelper : NSObject

+ (RSRAppHelper*)sharedInstance;

@property (strong, nonatomic) NSMutableDictionary *arrayListAll;

- (NSMutableDictionary*)dictionaryForSelectedFavList:(BOOL)fav;
- (void)loadFeed:(BOOL)loadNew;


+ (void)setStandartImageForImageView:(DFImageView*)imagePreview withItemFeed:(FeedItem*)itemFeed;


@end
