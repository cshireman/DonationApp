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
    
    observer = [OCMockObject observerMock];
    user = [[VPNUser alloc] init];
    
    receivedJSON = @"";
    receivedAPICall = nil;
}

-(void) tearDown
{
    manager = nil;
    delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    observer = nil;
    user = nil;
    
    receivedJSON = nil;
    receivedAPICall = nil;
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
    
    user.username = nil;
    user.password = nil;
    
    [manager startSessionForUser:user];
    
    [delegate verify];
}

-(void) testStartingSessionWithCompleteUserCallsCommunicator
{
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

-(void) testGetUserInfoStartsAPIRequestWhenForcedDownloadIsTrue
{
    NSString* fakeContent = @"{\"apiKey\":\"12C7DCE347154B5A8FD49B72F169A975\",\"session\":\"2DC23AC770C539DCCCA0175765\"}";
    
    id mockCommunicator = [OCMockObject mockForClass:[VPNCDCommunicator class]];
    [[mockCommunicator expect] makeAPICall:GetUserInfo withContent:fakeContent];
    manager.communicator = mockCommunicator;
    
    VPNSession* currentSession = [[VPNSession alloc] init];
    currentSession.session = @"2DC23AC770C539DCCCA0175765";
    [VPNSession setCurrentSessionWithSession:currentSession];

    manager.communicator = mockCommunicator;
    [manager getUserInfo:YES];
    
    [mockCommunicator verify];
}

-(void) testGetUserInfoChecksForLocalUserWhenForcedDownloadIsFalse
{
    VPNUser* testUser = [[VPNUser alloc] init];
    
    testUser.username = @"username";
    testUser.password = @"password";
    
    [testUser saveAsDefaultUser];
    [VPNUser saveUserToDisc:testUser];
    
    [[delegate expect] didGetUser:[OCMArg any]];
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"LoadingUserFromDisc" object:nil];
    
    [[observer expect] notificationWithName:@"LoadingUserFromDisc" object:[OCMArg any]];
    
    [manager getUserInfo:NO];
    
    [observer verify];
    
    [VPNUser deleteUserFromDisc];
}

-(void) testGetUserInfoMakesAPICallWhenNoLocalUserIsAvailableAndForcedDownloadIsFalse
{
    [VPNUser deleteUserFromDisc];
    
    NSString* fakeContent = @"{\"apiKey\":\"12C7DCE347154B5A8FD49B72F169A975\",\"session\":\"2DC23AC770C539DCCCA0175765\"}";
    
    id mockCommunicator = [OCMockObject mockForClass:[VPNCDCommunicator class]];
    [[mockCommunicator expect] makeAPICall:GetUserInfo withContent:fakeContent];
    manager.communicator = mockCommunicator;
    
    VPNSession* currentSession = [[VPNSession alloc] init];
    
    currentSession.session = @"2DC23AC770C539DCCCA0175765";
    
    [VPNSession setCurrentSessionWithSession:currentSession];
    
    manager.communicator = mockCommunicator;
    [manager getUserInfo:NO];
    
    [mockCommunicator verify];
}

-(void) testGetUserInfoCallsDelegateWhenLocalUserIsAvailableAndForcedDownloadIsFalse
{
    VPNUser* testUser = [[VPNUser alloc] init];
    
    testUser.username = @"username";
    testUser.password = @"password";
    
    [testUser saveAsDefaultUser];
    [VPNUser saveUserToDisc:testUser];
    
    [[delegate expect] didGetUser:[OCMArg any]];
    
    [manager getUserInfo:NO];
    
    [delegate verify];
    
    [VPNUser deleteUserFromDisc];
}

-(void) fakeAPICall:(APICallType*)apiCallType withContent:(NSString*)content
{
    receivedAPICall = apiCallType;
    receivedJSON = [content copy];
}

#pragma mark -
#pragma mark ChangePassword API Call

-(void) testChangePasswordAPICallCreatesCorrectJSONAndAPICall
{
    VPNSession* session = [VPNSession currentSession];
    session.session = @"CF0CFFF4B5B8685C3F33175794";
    [VPNSession setCurrentSessionWithSession:session];
    
    id mockCommunicator = [OCMockObject mockForClass:[VPNCDCommunicator class]];
    
    [[[mockCommunicator stub] andCall:@selector(fakeAPICall:withContent:) onObject:self] makeAPICall:[OCMArg any] withContent:[OCMArg any]] ;
    manager.communicator = mockCommunicator;
    
    [manager changePassword:@"NewPassword"];
    
    NSString* expectedJSON = @"{\"apiKey\":\"12C7DCE347154B5A8FD49B72F169A975\",\"session\":\"CF0CFFF4B5B8685C3F33175794\",\"newPassword\":\"NewPassword\"}";
    
    NSError* error = nil;
    NSDictionary* expectedResponse = [NSJSONSerialization JSONObjectWithData:[expectedJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    NSDictionary* receivedResponse = [NSJSONSerialization JSONObjectWithData:[receivedJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    STAssertEqualObjects(expectedResponse, receivedResponse, @"Received JSON should match expected JSON");
    STAssertEqualObjects(ChangePassword, receivedAPICall, @"Received API Call should be ChangePassword");
}

-(void) testChangePasswordThrowsErrorWithBlankPassword
{
    STAssertThrows([manager changePassword:@""], @"Should throw exception for blank password");
}

-(void) testChangePasswordThrowsErrorWithNilPassword
{
    STAssertThrows([manager changePassword:nil], @"Should throw exception for nil password");
}

-(void) testDidChangePasswordCalledWhenChangePasswordSucceeds
{
    [[delegate expect] didChangePassword];
    NSString* validChangePasswordResponse = @"{\"d\":{\"status\":\"SUCCESS\",\"reasonCode\":\"0\"}}";
    [manager receivedResponse:validChangePasswordResponse forAPICall:ChangePassword];
    
    [delegate verify];
}

-(void) testChangePasswordFailedWithErrorCalledWhenFailureSent
{
    [[delegate expect] changePasswordFailedWithError:[OCMArg any]];
    NSString* failureChangePasswordResponse = @"{\"d\":{\"status\":\"FAILURE\",\"errorCode\":\"2\",\"errorMessage\":\"Invalid Session\"}}";
    [manager receivedResponse:failureChangePasswordResponse forAPICall:ChangePassword];
    
    [delegate verify];
}

-(void) testChangePasswordFailedWhenManagerReceivedCommunicatorError
{
    [[delegate expect] changePasswordFailedWithError:[OCMArg any]];
    NSError* error = nil;
    [manager receivedError:error forAPICall:ChangePassword];
    
    [delegate verify];
}

#pragma mark -
#pragma mark UpdateUser API Call


-(void) testUpdateUserInfoAPICallCreatesCorrectJSONAndAPICall
{
    VPNSession* session = [VPNSession currentSession];
    session.session = @"CF0CFFF4B5B8685C3F33175794";
    [VPNSession setCurrentSessionWithSession:session];
    
    id mockCommunicator = [OCMockObject mockForClass:[VPNCDCommunicator class]];
    
    [[[mockCommunicator stub] andCall:@selector(fakeAPICall:withContent:) onObject:self] makeAPICall:[OCMArg any] withContent:[OCMArg any]] ;
    manager.communicator = mockCommunicator;
    
    VPNUser* testUser = [[VPNUser alloc] init];
    
    testUser.first_name = @"FirstName";
    testUser.last_name = @"LastName";
    testUser.email = @"email@email.com";
    testUser.company = @"Company";
    testUser.phone = @"1234567890";
    
    testUser.address1 = @"123 Happy St.";
    testUser.address2 = @"Suite #123";
    testUser.city = @"City";
    testUser.state = @"State";
    testUser.zip = @"ZipCode";
    
    testUser.is_email_opted_in = NO;
    
    [manager updateUserInfo:testUser];
    
    NSString* expectedJSON = @"{\"apiKey\":\"12C7DCE347154B5A8FD49B72F169A975\",\"session\":\"CF0CFFF4B5B8685C3F33175794\",\"firstName\":\"FirstName\",\"lastName\":\"LastName\",\"company\":\"Company\",\"email\":\"email@email.com\",\"phone\":\"1234567890\",\"address1\":\"123 Happy St.\",\"address2\":\"Suite #123\",\"city\":\"City\",\"state\":\"State\",\"zip\":\"ZipCode\",\"emailOptOut\":1}";
    
    NSError* error = nil;
    NSDictionary* expectedResponse = [NSJSONSerialization JSONObjectWithData:[expectedJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    NSDictionary* receivedResponse = [NSJSONSerialization JSONObjectWithData:[receivedJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    NSLog(@"%@",expectedJSON);
    NSLog(@"%@",receivedJSON);
    
    STAssertEqualObjects(expectedResponse, receivedResponse, @"Received JSON should match expected JSON");
    STAssertEqualObjects(UpdateUserInfo, receivedAPICall, @"Received API Call should be UpdateUserInfo");
}

-(void) testUpdateUserInfoThrowsErrorWithNilUser
{
    STAssertThrows([manager updateUserInfo:nil], @"Should throw exception for nil user");
}

-(void) testDidUpdateUserInfoCalledWhenUpdateUserInfoSucceeds
{
    [[delegate expect] didUpdateUserInfo];
    NSString* validUpdateUserInfoResponse = @"{\"d\":{\"status\":\"SUCCESS\",\"reasonCode\":\"0\"}}";
    [manager receivedResponse:validUpdateUserInfoResponse forAPICall:UpdateUserInfo];
    
    [delegate verify];
}

-(void) testUpdateUserInfoFailedWithErrorCalledWhenFailureSent
{
    [[delegate expect] updateUserInfoFailedWithError:[OCMArg any]];
    NSString* failureUpdateUserInfoResponse = @"{\"d\":{\"status\":\"FAILURE\",\"errorCode\":\"2\",\"errorMessage\":\"Invalid Session\"}}";
    [manager receivedResponse:failureUpdateUserInfoResponse forAPICall:UpdateUserInfo];
    
    [delegate verify];
}

-(void) testUpdateUserInfoFailedWhenManagerReceivedCommunicatorError
{
    [[delegate expect] updateUserInfoFailedWithError:[OCMArg any]];
    NSError* error = nil;
    [manager receivedError:error forAPICall:UpdateUserInfo];
    
    [delegate verify];
}

-(void) testNonConformingObjectCannotBeDelegate
{
    STAssertThrows(manager.delegate =
                   (id <VPNCDManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate",
                   @"as it doesn't conform to the delegate protocol");
}

-(void) testConformingObjectCanBeDelegate
{
    STAssertNoThrow(manager.delegate = delegate, @"Object conforming to the delegate protocol should be",@"as the delegate");
}

-(void) testAcceptsNilAsADelegate
{
    STAssertNoThrow(manager.delegate = nil,@"It should be possible to use nil as the objects delegate");
}

@end
