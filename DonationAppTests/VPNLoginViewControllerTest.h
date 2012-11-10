//
//  VPNLoginViewControllerTest.h
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VPNLoginViewController.h"
#import "VPNCDManagerDelegate.h"
#import "VPNCDManager.h"
#import "VPNUser.h"
#import "OCMock.h"

@interface VPNLoginViewControllerTest : SenTestCase <VPNLoginViewControllerDelegate>
{
    VPNLoginViewController* loginController;
    id delegate;
    id usernameField;
    id passwordField;
    id observer;
}

@end
