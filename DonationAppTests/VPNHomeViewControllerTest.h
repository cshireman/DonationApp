//
//  VPNHomeViewControllerTest.h
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VPNMainTabGroupViewController.h"
#import "VPNHomeViewController.h"

@interface VPNHomeViewControllerTest : SenTestCase

@property (strong, nonatomic) VPNHomeViewController* homeController;

@end

@interface FakeTabGroupController : VPNMainTabGroupViewController

@property BOOL selectTaxYearSceneCalled;
@property BOOL loginSceneCalled;

@end
