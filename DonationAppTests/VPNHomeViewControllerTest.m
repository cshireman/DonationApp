//
//  VPNHomeViewControllerTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNHomeViewControllerTest.h"

@implementation VPNHomeViewControllerTest
@synthesize homeController;

-(void) setUp
{
    self.homeController = [[VPNHomeViewController alloc] init];
    FakeTabGroupController* fakeTabController = [[FakeTabGroupController alloc] init];
    
    //self.homeController.tabBarController = fakeTabController;
}

@end

@implementation FakeTabGroupController
@synthesize selectTaxYearSceneCalled;
@synthesize loginSceneCalled;

-(id) init
{
    self = [super init];
    self.selectTaxYearSceneCalled = NO;
    self.loginSceneCalled = NO;
    
    return self;
}

-(void) displaySelectTaxYearScene
{
    self.selectTaxYearSceneCalled = YES;
}

-(void) displayLoginScene
{
    self.loginSceneCalled = YES;
}


@end
