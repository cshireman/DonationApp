//
//  VPNSession.m
//  DonationApp
//
//  Created by Chris Shireman on 10/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSession.h"

@implementation VPNSession

@synthesize session;
@synthesize first_name;
@synthesize last_name;
@synthesize annual_limit;

-(id) initWithDictionary:(NSDictionary*)info
{
    self = [super init];
    
    if(self)
    {
        session = [info objectForKey:@"session"];
        first_name = [info objectForKey:@"first_name"];
        last_name = [info objectForKey:@"last_name"];
        annual_limit = [[info objectForKey:@"annual_limit"] intValue];
    }
    
    return self;
}

@end
