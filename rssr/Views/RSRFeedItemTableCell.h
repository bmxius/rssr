//
//  RSRFeedItemTableCell.h
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DFImageManager/DFImageManagerKit+UI.h>
#import "FeedItem+CoreDataProperties.h"

@interface RSRFeedItemTableCell : UITableViewCell

@property (strong, nonatomic) FeedItem *itemFeed;

@property (strong, nonatomic) IBOutlet UILabel *labelDetail;
@property (strong, nonatomic) IBOutlet DFImageView *imagePreview;

@end
