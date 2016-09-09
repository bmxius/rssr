//
//  FeedItem+CoreDataProperties.h
//  
//
//  Created by Stig on 09.09.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FeedItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *dateUpdated;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSDate *dateAdded;
@property (nullable, nonatomic, retain) NSString *summary;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *mainURL;
@property (nullable, nonatomic, retain) NSString *mainName;
@property (nullable, nonatomic, retain) NSData *enclosures;

@end

NS_ASSUME_NONNULL_END
