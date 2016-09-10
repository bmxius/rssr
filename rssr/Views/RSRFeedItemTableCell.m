//
//  RSRFeedItemTableCell.m
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import "RSRFeedItemTableCell.h"
#import "Consts.h"

@interface RSRFeedItemTableCell ()

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;

@end

@implementation RSRFeedItemTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imagePreview.layer.cornerRadius = self.imagePreview.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemFeed:(FeedItem *)itemFeed{
    
    _itemFeed = itemFeed;
    if (itemFeed) {
        
        [self loadImageWithURL:self.itemFeed.imageURL];
        
        self.labelDate.text = [NSDateFormatter localizedStringFromDate:itemFeed.dateAdded dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        self.labelTitle.text = itemFeed.title;
        
//        if (itemFeed.summary) {
//            self.labelDetail.text = itemFeed.summary;
//        } else {
//            self.labelDetail.text = @"";
//        }
        
       // [self.labelDetail sizeToFit];
        
    } else {
        self.labelDate.text = @"";
        self.labelTitle.text = @"";
    }
}


- (void)loadImageWithURL:(NSString*)url{
    
    [RSRAppHelper setStandartImageForImageView:self.imagePreview withItemFeed:self.itemFeed];
    
    if (url) {
      
        self.imagePreview.allowsAnimations = YES; // Animates images when the response wasn't fast enough
        self.imagePreview.managesRequestPriorities = YES; // Automatically changes current request priority when image view gets added/removed from the window
        
        [self.imagePreview prepareForReuse];
        [self.imagePreview setImageWithResource:[NSURL URLWithString:url]];
    }
}


@end
