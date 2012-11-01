//
//  VPNCommunicatorTests.h
//  DonationApp
//
//  Created by Chris Shireman on 10/31/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VPNCDCommunicator.h"
#import "VPNCommunicatorDelegate.h"
#import "OCMock.h"

@interface VPNCommunicatorTests : SenTestCase
{
    VPNCDCommunicator* communicator;
    id delegate;
}

@end
