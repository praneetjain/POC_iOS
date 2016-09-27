//
//  MasterViewController.h
//  MobileChallenge
//
//  Created by Praneet Jain on 9/13/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController<NSXMLParserDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
//-(void)showErrorAlert;

@end

