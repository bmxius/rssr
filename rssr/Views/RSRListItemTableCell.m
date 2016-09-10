//
//  RSRListItemTableCell.m
//  rssr
//
//  Created by Stig on 10.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import "RSRListItemTableCell.h"
#import "Consts.h"
#import <MagicalRecord/MagicalRecord.h>

@interface RSRListItemTableCell ()

@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelURL;
@property (strong, nonatomic) IBOutlet UIButton *buttonFav;

@end


@implementation RSRListItemTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.buttonFav addTarget:self action:@selector(actionFav:) forControlEvents:kButtonAction];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemList:(ListItem *)itemList{
    
    _itemList = itemList;
    if (itemList) {
        self.buttonFav.hidden = NO;
        [self.buttonFav setSelected:[itemList.isFavorite boolValue]];
        self.labelName.text = itemList.name;
        self.labelURL.text = itemList.url;
        
    } else {
        self.buttonFav.hidden = YES;
        self.labelName.text = @"";
        self.labelURL.text = @"";
    }
}

- (IBAction)actionFav:(UIButton*)sender{
    
    [sender setSelected:!sender.isSelected];
    self.itemList.isFavorite = @(sender.isSelected);
    [self saveContext];
}

-(void)saveContext {
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
            
            
        } else if (error) {
            
        
        }
    }];
}

@end
