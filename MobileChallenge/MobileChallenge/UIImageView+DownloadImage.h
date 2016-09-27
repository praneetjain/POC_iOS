//
//  UIImageView+DownloadImage.h
//  MobileChallenge
//
//  Created by Praneet Jain on 9/15/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DownloadImage)

-(NSURLSessionDownloadTask*)loadImageWithURL:(NSURL*)url;
@end
