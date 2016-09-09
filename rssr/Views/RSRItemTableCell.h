//
//  RSRItemTableCell.h
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem+CoreDataProperties.h"

@interface RSRItemTableCell : UITableViewCell

@property (strong, nonatomic) FeedItem *itemFeed;

@end
