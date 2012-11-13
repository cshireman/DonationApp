//
//  VPNLoginViewControllerTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNLoginViewControllerTest.h"

@implementation VPNLoginViewControllerTest

-(void) setUp{
    loginController = [[VPNLoginViewController alloc] init];
    delegate = [OCMockObject mockForProtocol:@protocol(VPNLoginViewControllerDelegate)];
    
    loginController.delegate = delegate;
    
    usernameField = [OCMockObject mockForClass:[UITextField class]];
    passwordField = [OCMockObject mockForClass:[UITextField class]];
    observer = [OCMockObject observerMock];

}

-(void) tearDown
{
    loginController = nil;
    delegate = nil;
    
    usernameField = nil;
    passwordField = nil;
    observer = nil;
}

-(void) testLoginControllerConformsToManagerProtocol
{
    STAssertTrue([loginController conformsToProtocol:@protocol(VPNCDManagerDelegate)],@"login controller should conform to manager protocol");
}

-(void) testLoginControllerIsManagersDelegate
{
    STAssertEquals(loginController.manager.delegate, loginController, @"Login controller should be the managers delegate");
}

-(void) testPushingLoginWithValuesCallsStartSessionOnManager
{
    id manager = [OCMockObject mockForClass:[VPNCDManager class]];
    VPNUser* testUser = [[VPNUser alloc] init];
    testUser.username = @"media";
    testUser.username = @"test";
    
    loginController.user = testUser;
    
    [[[usernameField stub] andReturn:@"media"] text];
    [[[passwordField stub] andReturn:@"test"] text];
    
    loginController.usernameField = usernameField;
    loginController.passwordField = passwordField;
    
    [[manager expect] startSessionForUser:testUser];
    loginController.manager = manager;
    
    [loginController loginPushed:nil];
    
    [manager verify];
}

-(void) testBlankUsernameFieldTriggerzError
{    
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"BlankUsernameError" object:nil];
    
    [[observer expect] notificationWithName:@"BlankUsernameError" object:[OCMArg any]];
    
    [[[usernameField stub] andReturn:@""] text];
    [[[passwordField stub] andReturn:@"password"] text];
    
    loginController.usernameField = usernameField;
    loginController.passwordField = passwordField;
    
    [loginController loginPushed:nil];
    
    [observer verify];
    
}

-(void) testBlankPasswordFieldTriggerzError
{
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"BlankPasswordError" object:nil];
    
    [[observer expect] notificationWithName:@"BlankPasswordError" object:[OCMArg any]];
    
    [[[usernameField stub] andReturn:@"username"] text];
    [[[passwordField stub] andReturn:@""] text];
    
    loginController.usernameField = usernameField;
    loginController.passwordField = passwordField;
    
    [loginController loginPushed:nil];
    
    [observer verify];
}

-(void) testDidStartSessionCallsGetUserInfoOnManager
{
    id manager = [OCMockObject mockForClass:[VPNCDManager class]];
    [[manager expect] getUserInfo:YES];
    loginController.manager = manager;
    
    [loginController didStartSession];
    
    [manager verify];
}

-(void) testSessionErrorDisplaysError
{
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"InvalidLoginError" object:nil];
    
    [[observer expect] notificationWithName:@"InvalidLoginError" object:[OCMArg any]];

    [loginController startingSessionFailedWithError:nil];
    
    [observer verify];
}

-(void) testGetUserInfoErrorDisplaysError
{
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"GetUserInfoError" object:nil];
    
    [[observer expect] notificationWithName:@"GetUserInfoError" object:[OCMArg any]];
    
    [loginController getUserInfoFailedWithError:nil];
    
    [observer verify];
    
}

-(void) testGettingNilUserThrowsException
{
    STAssertThrows([loginController didGetUser:nil],@"Nil User returned should throw exception");
}

-(void) testGettingUserCallsForTaxYearDownload
{
    id mockManager = [OCMockObject mockForClass:[VPNCDManager class]];
    [[mockManager expect] getTaxYears:YES];
    
    loginController.manager = mockManager;
    
    [loginController didGetUser:[[VPNUser alloc] init]];
    
    [mockManager verify];
}

-(void) testGetTaxYearsErrorDisplaysError
{
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"GetTaxYearsError" object:nil];
    
    [[observer expect] notificationWithName:@"GetTaxYearsError" object:[OCMArg any]];
    
    [loginController getTaxYearsFailedWithError:nil];
    
    [observer verify];
}

-(void) testGetTaxYearsIsPassedNilThrowsError
{
    STAssertThrows([loginController didGetTaxYears:nil], @"Should throw error when nil tax years is returned");
}

-(void) testGetTaxYearsIsPassedEmptyArrayDisplaysError
{
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"GetTaxYearsEmptyError" object:nil];
    
    [[observer expect] notificationWithName:@"GetTaxYearsEmptyError" object:[OCMArg any]];
    
    [loginController didGetTaxYears:[NSArray array]];
    
    [observer verify];
    
}

-(void) testGetTaxYearsWithValidYearsCallsForOrganizationDownload
{
    NSMutableArray* taxYears = [NSMutableArray arrayWithObjects:@"2011",@"2012", nil];
    id mockManager = [OCMockObject mockForClass:[VPNCDManager class]];
    [[mockManager expect] getOrganizations:YES];
    
    loginController.manager = mockManager;
    
    [loginController didGetTaxYears:taxYears];
    
    [mockManager verify];
}

-(void) testGetOrganizationsErrorDisplaysError
{
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"GetOrganizationsError" object:nil];
    
    [[observer expect] notificationWithName:@"GetOrganizationsError" object:[OCMArg any]];
    
    [loginController getOrganizationsFailedWithError:nil];
    
    [observer verify];
}

-(void) testGetOrganizationsIsPassedNilThrowsError
{
    STAssertThrows([loginController didGetOrganizations:nil], @"Should throw error when nil organizations is returned");
}

-(void) testGetOrganizationsSendsLoginDismissalRequest
{
    NSArray* testOrgs = [NSArray arrayWithObjects:@"org1",@"org2", nil];
    [[delegate expect] loginControllerFinished];

    loginController.delegate = delegate;
    
    [loginController didGetOrganizations:testOrgs];
    
    [delegate verify];
}



@end
