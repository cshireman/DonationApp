//
//  VPNMockCDCommunicator.h
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNCDCommunicator.h"

@interface VPNMockCDCommunicator : VPNCDCommunicator
{
    BOOL wasAskedToStartSession;
}

-(BOOL) wasAskedToStartSession;

@end
