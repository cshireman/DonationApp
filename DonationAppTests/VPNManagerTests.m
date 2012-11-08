//
//  VPNManagerTests.m
//  DonationApp
//
//  Created by Chris Shireman on 11/7/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNManagerTests.h"

@implementation VPNManagerTests

-(void) setUp
{
    manager = [[VPNCDManager alloc] init];
    delegate = [OCMockObject mockForProtocol:@protocol(VPNCDManagerDelegate)];
    
    manager.delegate = delegate;
}

-(void) tearDown
{
    manager = nil;
    delegate = nil;
}

-(void) testManagerCreatedCommunicatorOnInit
{
    STAssertNotNil(manager.communicator, @"Communicator should have been created");
}

-(void) testManagerIsCommunicatorsDelegate
{
    STAssertEqualObjects(manager, manager.communicator.delegate, @"Manager should be the communicators delegate");
}

-(void) testManagerConformsToCommunicatorDelegateProtocol
{
    STAssertTrue([manager conformsToProtocol:@protocol(VPNCommunicatorDelegate)], @"Manager should conform to communicator protocol");
}

-(void) testStartingSessionWithNilUserSendsErrorToDelegate
{
    [[delegate expect] startingSessionFailedWithError:[OCMArg any]];
    
    [manager startSessionForUser:nil];
    
    [delegate verify];
}

-(void) testStartingSessionWithIncompleteUserSendsErrorToDelegate
{
    [[delegate expect] startingSessionFailedWithError:[OCMArg any]];
    
    VPNUser* user = [[VPNUser alloc] init];
    user.username = nil;
    user.password = nil;
    
    [manager startSessionForUser:user];
    
    [delegate verify];
}

-(void) testStartingSessionWithCompleteUserCallsCommunicator
{
    VPNUser* user = [[VPNUser alloc] init];
    user.username = @"media";
    user.password = @"test";
    
    id mockCommunicator = [OCMockObject mockForClass:[VPNCDCommunicator class]];
    [[mockCommunicator expect] makeAPICall:LoginUser withContent:[OCMArg any]];
    manager.communicator = mockCommunicator;
    
    [manager startSessionForUser:user];
    
    [mockCommunicator verify];
}

-(void) testReceivingValidSessionResponseCallsBuilder
{
    
}

-(void) testReceivingSessionErrorCallsDelegate
{
    
}

@end
