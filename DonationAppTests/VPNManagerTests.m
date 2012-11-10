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

-(void) testReceivingValidSessionResponseCreatesNewGlobalSessionAndCallsDelegate
{
    [[delegate expect] didStartSession];
    NSString* validSessionResponse = @"{\"d\":{\"status\":\"SUCCESS\",\"reasonCode\":\"0\",\"session\":\"0EC46E1F479E8890EA71175759\",\"firstName\":\"Joe\",\"lastName\":\"Test\",\"annualLimit\":15000}}";
    [manager receivedResponse:validSessionResponse forAPICall:LoginUser];
    
    
    VPNSession* currentSession = [VPNSession currentSession];
    STAssertEqualObjects(currentSession.session, @"0EC46E1F479E8890EA71175759", @"global session should have been set");
    
    [delegate verify];
}

-(void) testReceivingValidSessionResponseWithErrorSendsErrorToDelegate
{
    NSDictionary* errorInfo = [NSDictionary dictionaryWithObject:@"Invalid Username or Password" forKey:@"errorMessage"];
    NSError* testError = [NSError errorWithDomain:APIErrorDomain code:InvalidUsernameOrPasswordError userInfo:errorInfo];
    
    [[delegate expect] startingSessionFailedWithError:testError];
    
    NSString* errorSessionResponse = @"{\"d\":{\"status\":\"FAILURE\",\"errorCode\":3,\"errorSubCode\":0,\"errorMessage\":\"Invalid Username or Password\"}}";
    [manager receivedResponse:errorSessionResponse forAPICall:LoginUser];
    
    [delegate verify];
}

-(void) testReceivingSessionErrorCallsDelegate
{
    NSError* testError = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerErrorStartSessionCode userInfo:nil];
    
    [[delegate expect] startingSessionFailedWithError:testError];
    
    [manager receivedError:testError forAPICall:LoginUser];
    
    [delegate verify];
}

-(void) testReceivingNilSendsErrorToDelegate
{
    NSError* testError = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerErrorStartSessionCode userInfo:nil];
    
    [[delegate expect] startingSessionFailedWithError:testError];
    
    [manager receivedResponse:nil forAPICall:LoginUser];
    
    [delegate verify];
    
}

-(void) testReceivingEmptyResponseSendsErrorToDelegate
{
    NSError* testError = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:nil];
    
    [[delegate expect] startingSessionFailedWithError:testError];
    
    [manager receivedResponse:@"" forAPICall:LoginUser];
    
    [delegate verify];
}

-(void) testReceivingInvalidJSONResponseSendsErrorToDelegate
{
    NSError* testError = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:nil];
    
    [[delegate expect] startingSessionFailedWithError:testError];
    
    [manager receivedResponse:@"NotJSON" forAPICall:LoginUser];
    
    [delegate verify];
}



@end
