//
//  VPNSession.m
//  DonationApp
//
//  Created by Chris Shireman on 10/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSession.h"
#import "VPNAppDelegate.h"


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
        first_name = [info objectForKey:@"firstName"];
        last_name = [info objectForKey:@"lastName"];
        annual_limit = [[info objectForKey:@"annualLimit"] intValue];
    }
    
    return self;
}

-(void) populateWithDictionary:(NSDictionary*)info
{
    session = [info objectForKey:@"session"];
    first_name = [info objectForKey:@"firstName"];
    last_name = [info objectForKey:@"lastName"];
    annual_limit = [[info objectForKey:@"annualLimit"] intValue];    
}


+(VPNSession*) currentSession
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    return appDelegate.userSession;
}

+(void) clearCurrentSession
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.userSession = nil;
}

+(void) setCurrentSessionWithSession:(VPNSession*) newSession
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.userSession = newSession;
}



@end
