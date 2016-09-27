//
//  AlbumCell.h
//  MobileChallenge
//
//  Created by Praneet Jain on 9/14/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UILabel *albumArtist;
@property (weak, nonatomic) IBOutlet UILabel *albumPrice;

-(void)configureCell:(NSDictionary*)entry;
@end
