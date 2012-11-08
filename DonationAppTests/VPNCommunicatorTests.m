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
    STAssertNoThrow(communicator.delegate = delegate, @"Object conforming to the delegate protocol should be",@"as the delegate");
}

-(void) testCommunicatorAcceptsNilAsADelegate
{
    STAssertNoThrow(communicator.delegate = nil,@"It should be possible to use nil as the objects delegate");
}

-(void) testMakingAPICallWithInvalidAPICallTypeSendsErrorToDelegate
{
    APICallType* badCallType = (APICallType*)@"BadAPICallType";
    [[delegate expect] receivedError:[OCMArg any] forAPICall:@"BadAPICallType"];
    
    [communicator makeAPICall:badCallType withContent:@"Bad Content"];
    
    [delegate verify];
}

-(void) testMakingAPICallWithNilAPICallTypeSendsErrorToDelegate
{
    APICallType* badCallType = nil;
    [[delegate expect] receivedError:[OCMArg any] forAPICall:nil];
    
    [communicator makeAPICall:badCallType withContent:@"Bad Content"];
    
    [delegate verify];
}

-(void) testMakingValidAPICallWillStartConnection
{
    [communicator makeAPICall:LoginUser withContent:@"Some Content"];
    STAssertEqualObjects(communicator.currentCallType, LoginUser, @"Call Type should have been set");
    STAssertNotNil(communicator.currentConnection, @"Connection should have been created");
}

-(void) testFinishingConnectionWillSendResponseToDelegate
{
    communicator.currentCallType = LoginUser;
    NSString* testString = @"TestString";
    NSMutableData* testData = [NSMutableData dataWithBytes:[testString UTF8String] length:[testString length]];
    
    communicator.receivedData = testData;
    
    [[delegate expect] receivedResponse:testString forAPICall:LoginUser];
    [communicator connectionDidFinishLoading:nil];
    
    [delegate verify];
}




@end
