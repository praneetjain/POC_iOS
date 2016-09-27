//
//  Guide.h
//  ChallengeOne
//
//  Created by Praneet Jain on 6/9/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Guide : NSObject

@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, strong, readonly) NSString* city;
@property (nonatomic, strong, readonly) NSString* state;
@property (nonatomic, strong, readonly) NSString* startDate;
@property (nonatomic, strong, readonly) NSString* endDate;

-(instancetype)initGuideWithName:(NSString*)name city:(NSString*)city state:(NSString*)state startDate:(NSString*)startDate andEndDate:(NSString*)endDate;

@end
