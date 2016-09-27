//
//  SRQueue.m
//  ServerRequestQueueTest
//
//  Created by Praneet Jain on 8/3/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import "SRQueue.h"

@interface SRQueue(){
    
    NSMutableArray* requests;
}

@end

static SRQueue* queue = nil;
@implementation SRQueue

//Returns the shared instance of queue
+(SRQueue *)sharedQueueInstance{
    
    @synchronized (self) {
        if(queue == nil){
            queue = [[self alloc] init];
            [queue loadServerRequestsData];
        }
    }
    return queue;
}

//Singleton class, so returning an existing object
-(id)init{
    if(!queue){
        queue = [super init];
        requests = [[NSMutableArray alloc] init];
    }
    return queue;
}

//To add request in queue, returns YES after successful insertion
-(BOOL)enqueue:(ServerRequest*)requestObject{
    
    BOOL isInserted = NO;
    
    if (requestObject != nil) {
        [requests addObject:requestObject];
        [self saveServerRequestsData];
        isInserted = YES;
    }
    return isInserted;
}

//Removes and retuns object, which was inserted first
-(ServerRequest*)dequeue{
    
    ServerRequest* headObject;
    if(requests.count==0){
        return headObject;
    }
    
    headObject = [requests objectAtIndex:0];
    
    if(headObject != nil){
        [requests removeObjectAtIndex:0];
        [self saveServerRequestsData];
    }
    
    return headObject;
}

//Returns object(if any) at 0th index(element inserted first)
-(ServerRequest*)peek{
    
    ServerRequest* headObject;

    if(requests.count > 0){
        headObject = [requests objectAtIndex:0];
    }
    return headObject;
}

//Returns object(is any) at given index
-(ServerRequest*)peekAt:(int)index{
    
    ServerRequest* objectAtDesiredIndex;
    if(index >= 0 && index < requests.count){
    objectAtDesiredIndex = [requests objectAtIndex:index];
    }
    return objectAtDesiredIndex;
}

//Inserts object at desired index, returns YES after successful insertion
-(BOOL)insert:(ServerRequest*)anObject At:(int)index{
    
    BOOL isInserted = NO;
    
    if(anObject !=nil && index >= 0 && index <= requests.count){
        [requests insertObject:anObject atIndex:index];
        [self saveServerRequestsData];
        isInserted = YES;
    }
    
    return isInserted;
}

//Removes and returns object at desired index
-(ServerRequest*)removeAt:(int)index{
    
    ServerRequest* objectAtDesiredIndex;
    
    if(!(index >= 0 && index < requests.count)){
        return objectAtDesiredIndex;
    }
    objectAtDesiredIndex = [requests objectAtIndex:index];
    
    if(objectAtDesiredIndex != nil){
        [requests removeObjectAtIndex:index];
        [self saveServerRequestsData];
    }
    return objectAtDesiredIndex;
}

//Returns size(number of requests) of queue
-(int)getSize{
    
    return (int)[requests count];
}

//Return YES, if queue has no requests.
-(BOOL)isEmpty{
    
    if (requests.count == 0) {
        return YES;
    }
    return NO;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if ( self != nil )
    {
        //decode the properties
        requests = [aDecoder decodeObjectForKey:@"requests"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    //encode the properties
    [aCoder encodeObject:requests forKey:@"requests"];
}

//Saving the state, after every insert/ remove operation
-(void)saveServerRequestsData{
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:requests];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"requests"];
    [defaults synchronize];
}

//Reloading data in queue.
-(void)loadServerRequestsData{
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"requests"];
    if (encodedObject != nil) {
        requests = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    else{
        NSLog(@"No data found for requests.");
    }
}

@end
