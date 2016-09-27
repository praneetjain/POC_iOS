//
//  Guide.m
//  ChallengeOne
//
//  Created by Praneet Jain on 6/9/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import "Guide.h"

@implementation Guide

-(instancetype)initGuideWithName:(NSString *)name city:(NSString *)city state:(NSString *)state startDate:(NSString *)startDate andEndDate:(NSString *)endDate{

    self = [super init];
    if(self){
    
        _name = name;
        _city = city;
        _state = state;
        _startDate = startDate;
        _endDate = endDate;
        
    }
    return self;
}

@end
