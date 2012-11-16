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
#import "VPNSession.h"
#import "VPNUser.h"
#import "OCMock.h"

@interface VPNHomeViewControllerTest : SenTestCase
{
    VPNHomeViewController* homeController;
    VPNSession* session;
    VPNUser* user;
};

@end
