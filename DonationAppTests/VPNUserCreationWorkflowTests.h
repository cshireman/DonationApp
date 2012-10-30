//
//  VPNUserCreationTests.h
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VPNCDManager.h"
#import "VPNMockCDManagerDelegate.h"
#import "VPNMockCDCommunicator.h"
#import "VPNUser.h"
#import "VPNFakeUserBuilder.h"

@interface VPNUserCreationWorkflowTests : SenTestCase
{
    VPNCDManager* manager;
    VPNMockCDManagerDelegate* delegate;
    VPNFakeUserBuilder* builder;
    NSError* underlyingError;
    VPNUser* user;
}
@end
