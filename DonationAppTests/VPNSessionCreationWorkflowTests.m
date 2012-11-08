//
//  VPNUserCreationTests.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSessionCreationWorkflowTests.h"

@implementation VPNSessionCreationWorkflowTests

-(void) setUp
{
    manager = [[VPNCDManager alloc] init];
    delegate = [[VPNMockCDManagerDelegate alloc] init];
    manager.delegate = delegate;
    
    builder = [[VPNFakeSessionBuilder alloc] init];
    manager.sessionBuilder = builder;

    underlyingError = [NSError errorWithDomain:@"Test Domain" code:0 userInfo:nil];
    user = [[VPNUser alloc] init];
    user.username = @"media";
    user.password = @"pass";
}

-(void) tearDown
{
    manager = nil;
    delegate = nil;
    builder = nil;
    underlyingError = nil;
    user = nil;
}

-(void) testNonConformingObjectCannotBeDelegate
{
    STAssertThrows(manager.delegate =
                   (id <VPNCDManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate",
                   @"as it doesn't conform to the delegate protocol");
}

-(void) testConformingObjectCanBeDelegate
{
    STAssertNoThrow(manager.delegate = delegate, @"Object conforming to the delegate protocol should be",
                    @"as the delegate");
}

-(void) testManagerAcceptsNilAsADelegate
{
    STAssertNoThrow(manager.delegate = nil,@"It should be possible to use nil as the objects delegate");
}

//-(void) testAuthenticatingAUserStartsASession
//{
//    VPNMockCDCommunicator* communicator = [[VPNMockCDCommunicator alloc] init];
//    manager.communicator = communicator;
//        
//    [manager startSessionForUser:user];
//    STAssertTrue([communicator wasAskedToStartSession], @"The communicator should need to start a session");
//}

-(void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
    [manager startSessionForUserFailedWithError: underlyingError];
    STAssertFalse(underlyingError == [delegate fetchError], @"Error should be at the correct level of abstraction");
}

-(void)testErrorReturnedToDelegateDocumentsUnderlyingError
{
    [manager startSessionForUserFailedWithError: underlyingError];
    STAssertEqualObjects([[[delegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey],
                         underlyingError,
                        @"The underlying error should be available to the client");
}

@end
