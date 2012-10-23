//
//  VPNLoginViewControllerTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNLoginViewControllerTest.h"

@implementation VPNLoginViewControllerTest
@synthesize loginController;
@synthesize loginStatus;

-(void) setUp{
    self.loginController = [[VPNLoginViewController alloc] init];
    self.loginController.delegate = self;
}

-(void)testLoginButtonCanAuthenticateUser
{
    VPNUser* testUser = [[VPNUser alloc] init];
    testUser.username = @"chris@shireman.net";
    testUser.password = @"password";
    testUser.first_name = @"Christopher";
    testUser.last_name = @"Shireman";
    
    [testUser saveAsDefaultUser];
    
    self.loginController.usernameField = [[UITextField alloc] init];
    self.loginController.passwordField = [[UITextField alloc] init];
    
    self.loginController.usernameField.text = @"chris@shireman.net";
    self.loginController.passwordField.text = @"password";
    
    [self.loginController loginPushed:self];
    STAssertTrue(self.loginStatus, @"Login of default user should have worked");
}

-(void)testLoginButtonCanRejectInvalidUser
{
    VPNUser* testUser = [[VPNUser alloc] init];
    testUser.username = @"chris@shireman.net";
    testUser.password = @"password";
    testUser.first_name = @"Christopher";
    testUser.last_name = @"Shireman";
    
    [testUser saveAsDefaultUser];
    
    self.loginController.usernameField = [[UITextField alloc] init];
    self.loginController.passwordField = [[UITextField alloc] init];
    
    self.loginController.usernameField.text = @"chris@shireman.net";
    self.loginController.passwordField.text = @"notmypassword";
    
    [self.loginController loginPushed:self];
    STAssertFalse(self.loginStatus, @"Login of default user should have worked");
}


#pragma mark -
#pragma mark VPNLoginViewControllerDelegate Methods

-(void) loginController:(VPNLoginViewController*)login didFinish:(BOOL)status
{
    self.loginStatus = status;
}

@end
