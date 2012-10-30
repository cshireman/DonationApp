//
//  VPNMockCDCommunicator.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNMockCDCommunicator.h"

@implementation VPNMockCDCommunicator

-(void)startSessionForUser:(VPNUser*)user
{
    wasAskedToStartSession = YES;
}

-(BOOL)wasAskedToStartSession
{
    return wasAskedToStartSession;
}

@end
