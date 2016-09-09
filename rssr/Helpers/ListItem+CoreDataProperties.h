//
//  ListItem+CoreDataProperties.h
//  
//
//  Created by Stig on 09.09.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ListItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isFavorite;
@property (nullable, nonatomic, retain) NSDate *dateAdded;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *url;

@end

NS_ASSUME_NONNULL_END
