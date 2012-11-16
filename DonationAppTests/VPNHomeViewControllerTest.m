//
//  VPNHomeViewControllerTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNHomeViewControllerTest.h"

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

@end

