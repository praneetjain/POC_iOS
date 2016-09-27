//
//  UIImageView+DownloadImage.m
//  MobileChallenge
//
//  Created by Praneet Jain on 9/15/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import "UIImageView+DownloadImage.h"

@implementation UIImageView (DownloadImage)

//This method downloads image from url in background. Once downloaded, it updates the imageview for album.
-(NSURLSessionDownloadTask*)loadImageWithURL:(NSURL*)url{

    NSURLSession* session =[NSURLSession sharedSession];
    
    NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL* location, NSURLResponse* response, NSError* error) {
        
        if(error==nil){
        
            NSData* data = [NSData dataWithContentsOfURL:url];
            if(data!=nil){
            UIImage* image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
            });
            }
        }
        
    }];
    
    [downloadTask resume];
    
    return downloadTask;
    
    
  }

@end
