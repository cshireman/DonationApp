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

static VPNSession* currentSession = nil;

-(id) initWithDictionary:(NSDictionary*)info
{
    self = [super init];
    
    if(self)
    {
        session = [info objectForKey:@"session"];
        first_name = [info objectForKey:@"firstName"];
        last_name = [info objectForKey:@"lastName"];
        annual_limit = [[info objectForKey:@"annualLimit"] intValue];
    }
    
    return self;
}

-(void) setAsCurrentSession
{
    currentSession = self;
}

+(id) currentSession
{
    return currentSession;
}

+(void) clearCurrentSession
{
    currentSession = nil;
}



@end