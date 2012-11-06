//
//  VPNCommunicatorTests.m
//  DonationApp
//
//  Created by Chris Shireman on 10/31/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNCommunicatorTests.h"

@implementation VPNCommunicatorTests

-(void) setUp
{
    communicator = [[VPNCDCommunicator alloc] init];
    delegate = [OCMockObject mockForProtocol:@protocol(VPNCommunicatorDelegate)];
    
    communicator.delegate = delegate;
}

-(void) tearDown
{
    communicator = nil;
}

-(void) testNonConformingObjectCannotBeDelegate
{
    STAssertThrows(communicator.delegate =
                   (id <VPNCommunicatorDelegate>)[NSNull null], @"NSNull should not be used as the delegate",
                   @"as it doesn't conform to the delegate protocol");
}

-(void) testConformingObjectCanBeDelegate
{
    STAssertNoThrow(communicator.delegate = delegate, @"Object conforming to the delegate protocol should be",
                    @"as the delegate");
}

-(void) testCommunicatorAcceptsNilAsADelegate
{
    STAssertNoThrow(communicator.delegate = nil,@"It should be possible to use nil as the objects delegate");
}

-(void) testCurrentCallTypeSetToLoginWhenStartingSession
{
    VPNUser* user = [[VPNUser alloc] init];
    user.username = @"media";
    user.password = @"test";

    [communicator startSessionForUser:user];
    STAssertEqualObjects(LoginUser, communicator.currentCallType, @"Call type should have been set to LoginUser");
}

-(void) testNilUserShouldThrowExceptionWhenStartingSession
{
    STAssertThrows([communicator startSessionForUser:nil], @"User is required to start a session");
}

-(void) testBlankUsernameWillSendErrorToDelegate
{
    [[delegate expect] receivedError:[OCMArg any]];
    VPNUser* user = [[VPNUser alloc] init];
    
    [communicator startSessionForUser:user];
    [delegate verify];
}

//-(void) testStartingSessionCallCreatesConnection
//{
//    VPNUser* user = [[VPNUser alloc] init];
//    user.username = @"media";
//    user.password = @"test";
//
//    [communicator startSessionForUser:user];
//    STAssertNotNil(communicator.currentConnection, @"Connection should have been created");
//}


@end
