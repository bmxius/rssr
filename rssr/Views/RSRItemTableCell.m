//
//  RSRItemTableCell.m
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import "RSRItemTableCell.h"
#import "Consts.h"
#import <DFImageManager/DFImageManagerKit+UI.h>

@interface RSRItemTableCell ()

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet DFImageView *imagePreview;

@end

@implementation RSRItemTableCell

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
        
        //[RSRAppHelper setStandartImageForImageView:self.imagePreview withItemFeed:itemFeed];
        self.imagePreview.image = nil;
        if (itemFeed.enclosures) {
            NSMutableArray *enclosures = [NSKeyedUnarchiver unarchiveObjectWithData:itemFeed.enclosures];
            if (enclosures.count>0 && enclosures[0][@"url"]) {
                [self loadImageWithURL:enclosures[0][@"url"]];
            } else {
                [self findImageInItemFeed:itemFeed];
            }
        } else if (itemFeed.content){
            [self findImageInItemFeed:itemFeed];
        }
        
        self.labelDate.text = [NSDateFormatter localizedStringFromDate:itemFeed.dateAdded dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        self.labelTitle.text = itemFeed.title;
        
    } else {
        self.imagePreview.image = nil;
        self.labelDate.text = @"";
        self.labelTitle.text = @"";
    }
}

- (void)findImageInItemFeed:(FeedItem*)itemFeed{
    
    if (!itemFeed.content){
        [RSRAppHelper setStandartImageForImageView:self.imagePreview withItemFeed:self.itemFeed];
        return;
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    [regex enumerateMatchesInString:itemFeed.content
                            options:0
                              range:NSMakeRange(0, [itemFeed.content length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             NSString *img = [itemFeed.content substringWithRange:[result rangeAtIndex:2]];
                             if (img) {
                                 [self loadImageWithURL:img];
                             } else {
                                   [RSRAppHelper setStandartImageForImageView:self.imagePreview withItemFeed:self.itemFeed];
                             }
                         }];
}

- (void)loadImageWithURL:(NSString*)url{
    
    if (url) {
        [[DFImageManager imageTaskForResource:[NSURL URLWithString:url] completion:^(UIImage *image, NSError *error, DFImageResponse *response, DFImageTask *task){
           
            [self.imagePreview setImage:image];
            
        }] resume];
    } else {
       [RSRAppHelper setStandartImageForImageView:self.imagePreview withItemFeed:self.itemFeed];
    }
}


@end
