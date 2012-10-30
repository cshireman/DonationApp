//
//  VPNUserSignupViewControllerTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNUserSignupViewControllerTest.h"
#import "VPNUser.h"

@implementation VPNUserSignupViewControllerTest
@synthesize signupController;

-(void)setUp{
    [super setUp];
    self.signupController = [[VPNUserSignupViewController alloc] init];
}


-(void) testThatSubmitPushedCanSaveUserInformation
{
    self.signupController.firstNameField = [[UITextField alloc] init];
    self.signupController.lastNameField = [[UITextField alloc] init];
    self.signupController.emailField = [[UITextField alloc] init];
    self.signupController.passwordField = [[UITextField alloc] init];
    self.signupController.confirmPasswordField = [[UITextField alloc] init];
    
    self.signupController.firstNameField.text = @"Test";
    self.signupController.lastNameField.text = @"User";
    self.signupController.emailField.text = @"test@user.com";
    self.signupController.passwordField.text = @"password";
    self.signupController.confirmPasswordField.text = @"password";
    
    [self.signupController submitPushed:self];
    VPNUser* loadedUser = [VPNUser loadUserFromDisc];
    STAssertEqualObjects(loadedUser.username, @"test@user.com", @"Submitted User doesn't match saved user");
    STAssertEqualObjects(loadedUser.password, @"password", @"Submitted password doesn't match saved password");
}

@end
