//
//  AlbumCell.m
//  MobileChallenge
//
//  Created by Praneet Jain on 9/14/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import "AlbumCell.h"
#import "UIImageView+DownloadImage.h"

//Macros to get current device details.
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//Constants
NSString *const Key_PLACEHOLDER_IMAGE = @"placeholder";
NSString *const Key_IMAGE_55 = @"image55";
NSString *const Key_IMAGE_60 = @"image60";
NSString *const Key_IMAGE_170 = @"image170";
NSString *const Key_TITLE = @"title";
NSString *const Key_PRICE = @"price";

@interface AlbumCell()
{
    NSURLSessionDownloadTask* downloadTask;
}
@end

@implementation AlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Configuring all the values from rss feed in imageview and labels
-(void)configureCell:(NSDictionary*)entry{

    //Setting the shadow
    [self setLayerOnView:self.backgroundView];
    [self setLayerOnView:self.albumImageView];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowRadius = 4.0f;
    self.layer.shadowOpacity = 0.1f;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    
    NSArray* arrayTitleAndArtist = [self getTitleAndArtist:entry];
    
    [self.albumName setText:[[arrayTitleAndArtist objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    [self.albumArtist setText:[[arrayTitleAndArtist objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    [self.albumPrice setText:[self formatPriceValue:[entry objectForKey:Key_PRICE]]];
    [self.albumImageView setImage:[UIImage imageNamed:Key_PLACEHOLDER_IMAGE]];
    
    //picking the image url, as per the resolution of current device
    NSString* stringURL = nil;
    if (IS_IPHONE_4_OR_LESS) {
        stringURL = [entry objectForKey:Key_IMAGE_55];
    }
    else if(IS_IPHONE_5){
    stringURL = [entry objectForKey:Key_IMAGE_60];
    }
    else{
        //if device is iPhone6/plus, iPad or bigger
    stringURL = [entry objectForKey:Key_IMAGE_170];
    }
    
    NSString* tempStringURL = [stringURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* finalStringURL = [tempStringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:finalStringURL];
    
    //albumImageView would show image downloaded from url
    [self.albumImageView loadImageWithURL:url];
}

//Splitting the title string from server into "title" and "artist name"
//and returning these two values in an array with index 0 and 1 respectively.
-(NSArray*)getTitleAndArtist:(NSDictionary*)entry{

    NSString* titleString = [entry objectForKey:Key_TITLE];
    
    return [titleString componentsSeparatedByString:@"-"];
}

//Formatting price value by limiting the decimal value to 2 points
//and adding "$" as a prefix.
-(NSString*)formatPriceValue:(NSString*) price{

    return [NSString stringWithFormat:@"$%@",[price substringToIndex:4]];
}


//Setting the layer properties for backgroundView and imageView.
-(void)setLayerOnView:(UIView*)view{
    
    if ([view isKindOfClass:[UIImageView class]]) {
        view.layer.cornerRadius = 12.0f;
    }
    else{
        view.layer.cornerRadius = 4.0f;
    }
    view.layer.borderWidth = 3.0f;
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.masksToBounds = YES;
    
}

//If a cell has to be reused, because of scrolling, then the current download should be stopped, as new download should begin for new rows.
-(void)prepareForReuse{
    
    [super prepareForReuse];
    [downloadTask cancel];
    downloadTask = nil;
    self.albumName.text = nil;
    self.albumArtist.text = nil;
    self.albumPrice.text = nil;
    self.albumImageView.image = nil;
}


@end
