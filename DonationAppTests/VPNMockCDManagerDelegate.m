//
//  VPNMockCDManagerDelegate.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNMockCDManagerDelegate.h"

@implementation VPNMockCDManagerDelegate
@synthesize fetchError;
@synthesize receivedUser;

-(void) startingSessionFailedWithError:(NSError*)error
{
    self.fetchError = error;
}

-(void) didStartSessionWithUser:(VPNUser*)user
{
    self.receivedUser = user;
}
@end
