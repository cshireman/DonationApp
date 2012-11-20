//
//  VPNHomeViewControllerTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNHomeViewControllerTest.h"
#import "VPNAppDelegate.h"

@implementation VPNHomeViewControllerTest

-(void) setUp
{
    homeController = [[VPNHomeViewController alloc] init];
    session = [[VPNSession alloc] init];
    user = [[VPNUser alloc] init];
}

-(void) tearDown
{
    homeController = nil;
    session = nil;
    user = nil;
}

-(void) testLogoutPushedClearsCurrentSessionID
{
    session.session = @"Test Session";
    homeController.session = session;
    
    [homeController logoutPushed:nil];
    
    VPNSession* sessionResult = homeController.session;
    STAssertTrue(sessionResult != session,@"Session should have been cleared");
}

-(void) testLogoutPushedClearsCurrentlySelectedTaxYear
{
    user.selected_tax_year = 2012;
    homeController.user = user;
    
    [homeController logoutPushed:nil];
    
    STAssertEquals(0, homeController.user.selected_tax_year, @"Selected tax year should have been reset");
}

-(void) testLogoutPushedSendsLogoutNotification
{
    id observer = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"Logout" object:nil];
    
    [[observer expect] notificationWithName:@"Logout" object:[OCMArg any]];
    
    [homeController logoutPushed:nil];
    
    [observer verify];
}

-(void) testViewDidLoadAssignsLocalTextFieldReferences
{
    homeController.nameField = nil;
    homeController.emailField = nil;
    homeController.passwordField = nil;
    homeController.confirmPasswordField = nil;
    homeController.taxSavingsLabel = nil;
    
    [homeController viewDidLoad];
    
    STAssertNotNil(homeController.nameField, @"Name Field should have been assigned");
    STAssertNotNil(homeController.emailField, @"Email Field should have been assigned");
    STAssertNotNil(homeController.passwordField, @"Password Field should have been assigned");
    STAssertNotNil(homeController.confirmPasswordField, @"Confirm Password Field should have been assigned");
    STAssertNotNil(homeController.taxSavingsLabel, @"Tax Savings Label should have been assigned");
}

-(void) testTaxSavingsIsDisplayedFromGlobalValue
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.currentTaxSavings = 100.25;
    
    [homeController viewDidLoad];
    
    NSString* expectedResult = @"$100.25";
    STAssertEqualObjects(expectedResult, homeController.taxSavingsLabel.text, @"Tax Savings should have been set with value from app delegate");
}


-(void) testUpdateButtonDoesReadValuesFromFields
{
    id passwordFieldMock = [OCMockObject mockForClass:[UITextField class]];
    id confirmPasswordFieldMock = [OCMockObject mockForClass:[UITextField class]];
    
    [[passwordFieldMock expect] text];
    [[confirmPasswordFieldMock expect] text];
    
    homeController.passwordField = passwordFieldMock;
    homeController.confirmPasswordField = confirmPasswordFieldMock;
    
    id mockManager = [OCMockObject mockForClass:[VPNCDManager class]];
    [[mockManager stub] getUserInfo:YES];
    
    homeController.manager = mockManager;
    
    [homeController updatePushed:nil];
    
    [passwordFieldMock verify];
    [confirmPasswordFieldMock verify];
}

-(void) testUpdateButtonValidatesPasswordsIfFieldsNotBlank
{
    id passwordMock = [OCMockObject mockForClass:[NSString class]];
    id passwordFieldMock = [OCMockObject mockForClass:[UITextField class]];
    id confirmPasswordMock = [OCMockObject mockForClass:[NSString class]];
    id confirmPasswordFieldMock = [OCMockObject mockForClass:[UITextField class]];
    
    [[passwordMock expect] isEqualToString:[OCMArg any]];
    
    [[[passwordMock stub] andReturnValue:OCMOCK_VALUE((NSUInteger){5})] length];
    [[[passwordFieldMock stub] andReturn:passwordMock] text];
    
    [[[confirmPasswordMock stub] andReturnValue:OCMOCK_VALUE((NSUInteger){5})] length];
    [[[confirmPasswordFieldMock stub] andReturn:passwordMock] text];
    
    homeController.passwordField = passwordFieldMock;
    homeController.confirmPasswordField = confirmPasswordFieldMock;

    id mockManager = [OCMockObject mockForClass:[VPNCDManager class]];
    [[mockManager stub] getUserInfo:YES];
    
    homeController.manager = mockManager;

    [homeController updatePushed:nil];
    
    [passwordMock verify];
}

-(void) testValidatePasswordsDisplaysErrorWhenPasswordsDontMatch
{
    UITextField* passwordField = [[UITextField alloc] init];
    UITextField* confirmPasswordField = [[UITextField alloc] init];
    
    passwordField.text = @"Something";
    confirmPasswordField.text = @"NotSomething";
    
    homeController.passwordField = passwordField;
    homeController.confirmPasswordField = confirmPasswordField;
    
    id observer = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"PasswordMismatchError" object:nil];
    
    [[observer expect] notificationWithName:@"PasswordMismatchError" object:[OCMArg any]];
    
    [homeController updatePushed:nil];
    
    [observer verify];
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

-(void) testValidatePasswordsDoesNotDisplayErrorWhenPasswordsMatch
{
    UITextField* passwordField = [[UITextField alloc] init];
    UITextField* confirmPasswordField = [[UITextField alloc] init];
    
    passwordField.text = @"Something";
    confirmPasswordField.text = @"Something";
    
    homeController.passwordField = passwordField;
    homeController.confirmPasswordField = confirmPasswordField;
    
    id mockManager = [OCMockObject mockForClass:[VPNCDManager class]];
    [[mockManager stub] getUserInfo:YES];
    
    [[mockManager expect] changePassword:[OCMArg any]];
    [[mockManager stub] changePassword:@"Something"];
    
    homeController.manager = mockManager;    
    
    id observer = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"PasswordsMatch" object:nil];
    
    [[observer expect] notificationWithName:@"PasswordsMatch" object:[OCMArg any]];
    
    [homeController updatePushed:nil];
    
    [observer verify];
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    
}

-(void) testChangePasswordAPICallIsMadeWhenUpdateIsPushedAndPasswordsValidate
{
    UITextField* passwordField = [[UITextField alloc] init];
    UITextField* confirmPasswordField = [[UITextField alloc] init];
    
    passwordField.text = @"Something";
    confirmPasswordField.text = @"Something";
    
    homeController.passwordField = passwordField;
    homeController.confirmPasswordField = confirmPasswordField;

    id mockManager = [OCMockObject mockForClass:[VPNCDManager class]];
    [[mockManager expect] changePassword:@"Something"];
    [[mockManager expect] getUserInfo:YES];
    
    homeController.manager = mockManager;
    
    [homeController updatePushed:nil];
    
    [mockManager verify];
}

-(void) testUpdateUserInfoIsCalledWithCollectedInfoWhenUpdateButtonIsPushed
{
    id mockManager = [OCMockObject mockForClass:[VPNCDManager class]];
    [[mockManager expect] getUserInfo:YES];
    
    homeController.manager = mockManager;
    
    [homeController updatePushed:nil];
    
    [mockManager verify];
}

-(void) testDidGetUserInfoReadsValuesFromFields
{
    id nameFieldMock = [OCMockObject mockForClass:[UITextField class]];
    id emailFieldMock = [OCMockObject mockForClass:[UITextField class]];
    
    [[nameFieldMock expect] text];
    [[emailFieldMock expect] text];
    
    homeController.nameField = nameFieldMock;
    homeController.emailField = emailFieldMock;
    
    [homeController didGetUser:user];
    
    [nameFieldMock verify];
    [emailFieldMock verify];
}

-(void) testDidGetUserSetsValuesFromTextFields
{
    UITextField* nameField = [[UITextField alloc] init];
    UITextField* emailField = [[UITextField alloc] init];
    
    nameField.text = @"User Name";
    emailField.text = @"user@email.com";
    
    homeController.nameField = nameField;
    homeController.emailField = emailField;
    
    id userMock = [OCMockObject mockForClass:[VPNUser class]];
    
    [[userMock expect] setFirst_name:@"User"];
    [[userMock expect] setLast_name:@"Name"];
    [[userMock expect] setEmail:@"user@email.com"];
    
    [homeController didGetUser:userMock];
    
    [userMock verify];
}

-(void) testSuccessMessageDisplayedWhenUpdateCompleted
{
    id observer = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observer name:@"UserInfoUpdated" object:nil];
    
    [[observer expect] notificationWithName:@"UserInfoUpdated" object:[OCMArg any]];
    
    [homeController didUpdateUserInfo];
    
    [observer verify];
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    
}

@end

