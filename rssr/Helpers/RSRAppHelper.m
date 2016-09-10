//
//  RSRAppHelper.m
//  rssr
//
//  Created by Stig on 09.09.16.
//  Copyright © 2016 YESS. All rights reserved.
//

#import "RSRAppHelper.h"
#import "Consts.h"


@interface RSRAppHelper () <MWFeedParserDelegate>
{
    NSArray *_defaultsListAll;
    int _loadCounter;
    int _errorCounter;
    int _imageFinders;
    MWFeedParser *feedParser;
    ListItem *_currentListItem;
}


@end


@implementation RSRAppHelper

+ (RSRAppHelper*)sharedInstance
{
    static dispatch_once_t pred;
    static id sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        _defaultsListAll = [ListItem MR_findAllSortedBy:@"dateAdded" ascending:YES];
    }
    return self;
}

- (void)loadNewFeed:(BOOL)loadNew{

    if ([Utils isOnline]) {
        
        [FeedItem MR_truncateAll];
        _loadCounter = 0;
        _errorCounter = 0;
        if (loadNew) {
            _defaultsListAll = [ListItem MR_findAllSortedBy:@"dateAdded" ascending:YES];
        }
        if (!_defaultsListAll.count) {
            kPostNotif(kNotificationFeed, @(0));
            return;
        }
        [self nextLoad];
    } else {
        kPostNotif(kNotificationFeed, @(0));
    }
}

- (void)nextLoad{
    
    if (_loadCounter == _defaultsListAll.count) {
        [self saveContext];
        
    } else {
        
        ListItem *item = _defaultsListAll[_loadCounter];
        _currentListItem = item;
        [self loadFeedFromURLString:item.url];
        _loadCounter++;
    }
}

- (void)listItemsLoaded{
    
    kPostNotif(kNotificationFeed, @(_errorCounter));
}

- (void)loadFeedFromURLString:(NSString*)urlString{
    
    feedParser = [[MWFeedParser alloc] initWithFeedURL:[NSURL URLWithString:urlString]];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull;
    
    feedParser.connectionType = ConnectionTypeAsynchronously;

    [feedParser parse];
}

#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser{
    
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    
    FeedItem *feed = [FeedItem MR_createEntity];
    feed.identifier = item.identifier;
    feed.title = item.title;
    feed.link = item.link;
    feed.summary = item.summary;
    feed.content = item.content;
    feed.author = item.author;
    feed.dateAdded = item.date;
    feed.dateUpdated = item.updated;
    feed.mainURL = _currentListItem.url;
    feed.mainName = _currentListItem.name;
    
    if (item.enclosures) {
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:item.enclosures];
        feed.enclosures = arrayData;
    }
    
    [self findImageInItemFeed:feed];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser{
    
    [self nextLoad];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    
    _errorCounter++;
    [self nextLoad];
}

-(void)saveContext {
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
        
            [self listItemsLoaded];
            
        } else if (error) {
           
        }
    }];
}


- (void)findImageInItemFeed:(FeedItem*)itemFeed{
    
    if (itemFeed.enclosures) {
        NSMutableArray *enclosures = [NSKeyedUnarchiver unarchiveObjectWithData:itemFeed.enclosures];
        if (enclosures.count>0 && enclosures[0][@"url"]) {
            itemFeed.imageURL = enclosures[0][@"url"];
            return;
        } else {
            
        }
    }
    
    if (!itemFeed.content){
        return;
    }
    
    _imageFinders ++;
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
                                 itemFeed.imageURL = img;
                             } else {
                                 
                             }
                             _imageFinders--;
                         }];
}

#pragma mark helpers

+ (void)setStandartImageForImageView:(DFImageView*)imagePreview withItemFeed:(FeedItem*)itemFeed{
    
    if (!imagePreview.image) {
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: style,
                                     NSFontAttributeName            : [UIFont systemFontOfSize:30],
                                     NSForegroundColorAttributeName : kColorLight,
                                     NSBackgroundColorAttributeName : kColorOrangeNav};
        
        NSString *letter = [NSString stringWithFormat:@"%@",[[itemFeed.mainName substringToIndex:1] uppercaseString]];
        
        imagePreview.image = [self imageFromString:letter attributes:attributes size:imagePreview.bounds.size];
        imagePreview.backgroundColor = kColorOrangeNav;
    }
}

+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGSize sizer = [string sizeWithAttributes:attributes];
    [string drawInRect:CGRectMake(0, 0 + (size.height - sizer.height)/2.0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end





