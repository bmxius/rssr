//
//  RSRListItemTableCell.h
//  rssr
//
//  Created by Stig on 10.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem+CoreDataProperties.h"

@interface RSRListItemTableCell : UITableViewCell

@property (strong, nonatomic) ListItem *itemList;

@end
