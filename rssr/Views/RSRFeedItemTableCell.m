//
//  RSRFeedItemTableCell.m
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import "RSRFeedItemTableCell.h"
#import "Consts.h"
#import <DFImageManager/DFImageManagerKit+UI.h>

@interface RSRFeedItemTableCell ()

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UILabel *labelDetail;
@property (strong, nonatomic) IBOutlet DFImageView *imagePreview;

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
        
        self.imagePreview.image = nil;
        self.imagePreview.backgroundColor = [UIColor clearColor];
        
        [self loadImageWithURL:self.itemFeed.imageURL];
        
        self.labelDate.text = [NSDateFormatter localizedStringFromDate:itemFeed.dateAdded dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        self.labelTitle.text = itemFeed.title;
        
        if (itemFeed.summary) {
            self.labelDetail.text = itemFeed.summary;
        } else {
            self.labelDetail.text = @"";
        }
    } else {
        self.imagePreview.image = nil;
        self.labelDate.text = @"";
        self.labelTitle.text = @"";
    }
}


- (void)loadImageWithURL:(NSString*)url{
    
    if (url) {
        [[DFImageManager imageTaskForResource:[NSURL URLWithString:url] completion:^(UIImage *image, NSError *error, DFImageResponse *response, DFImageTask *task){
            if (image && !error) {
                [self.imagePreview setImage:image];
            } else {
                [RSRAppHelper setStandartImageForImageView:self.imagePreview withItemFeed:self.itemFeed];
            }
        }] resume];
    } else {
       [RSRAppHelper setStandartImageForImageView:self.imagePreview withItemFeed:self.itemFeed];
    }
}


@end
