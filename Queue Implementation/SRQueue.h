//
//  SRQueue.h
//  ServerRequestQueueTest
//
//  Created by Praneet Jain on 8/3/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequest.h"

@interface SRQueue : NSObject<NSCoding>

+(SRQueue*)sharedQueueInstance;

-(BOOL)enqueue:(ServerRequest*)anObject;

-(ServerRequest*)dequeue;

-(ServerRequest*)peek;

-(ServerRequest*)peekAt:(int)index;

-(BOOL)insert:(ServerRequest*)anObject At:(int)index;

-(ServerRequest*)removeAt:(int)index;

-(int)getSize;

-(BOOL)isEmpty;

@end
