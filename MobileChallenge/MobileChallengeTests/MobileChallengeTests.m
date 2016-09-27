//
//  MobileChallengeTests.m
//  MobileChallengeTests
//
//  Created by Praneet Jain on 9/13/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MasterViewController.h"

@interface MobileChallengeTests : XCTestCase

@end

@implementation MobileChallengeTests

MasterViewController* vc;


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSString* urlString = @"https://itunes.apple.com/us/album/cancer/id1152679154?i=1152679212&uo=2";
    
    [self testURLValidity:urlString];
    
    vc = [[MasterViewController alloc]init];
    
    [self testAlertView];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testURLValidity:(NSString*)urlString{
    
    
    NSString* tempFeedURl = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* trimmedStringURL = [tempFeedURl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString* final = [trimmedStringURL stringByReplacingOccurrencesOfString:@"&uo=2" withString:@"&ign-mpt=uo%3D2"];
    
    NSString* stringFromBrowser = @"https://itunes.apple.com/us/album/cancer/id1152679154?i=1152679212&ign-mpt=uo%3D2";
    
    XCTAssert([final isEqualToString:stringFromBrowser],@"Both url strings should be same");
    
}

-(void)testAlertView{

    //Uncomment below line and showErrorAlert in MasterViewController.h to test this
//    [vc showErrorAlert];

}


@end
