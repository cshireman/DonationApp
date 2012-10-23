//
//  VPNLoginViewControllerTest.h
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VPNLoginViewController.h"
#import "VPNUser.h"

@interface VPNLoginViewControllerTest : SenTestCase <VPNLoginViewControllerDelegate>

@property BOOL loginStatus;
@property (strong, nonatomic) VPNLoginViewController* loginController;

@end
