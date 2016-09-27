//
//  DetailViewController.m
//  MobileChallenge
//
//  Created by Praneet Jain on 9/13/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    NSString* detailedLink;
}
@property (weak, nonatomic) IBOutlet UIWebView *webViewAlbum;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
        NSString* temp = [self.detailItem objectForKey:@"title"];
        
        //Getting index 0, which contains title to show
        NSString* navTitle = [[[temp componentsSeparatedByString:@"-"] objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
        self.navigationItem.title = navTitle;
        
        NSString* feedURL = (NSString*)[self.detailItem objectForKey:@"id"];
        
        
        NSString* tempFeedURl = [feedURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString* trimmedStringURL = [tempFeedURl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSURL *url = [NSURL URLWithString:trimmedStringURL];
        
        //Load the HTML page in embedded WebView, otherwise this iTunes URL would open safari browser
        NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        [self.webViewAlbum loadHTMLString:responseString baseURL:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
