//
//  VPNManagerTests.h
//  DonationApp
//
//  Created by Chris Shireman on 11/7/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VPNCDManager.h"
#import "VPNCDManagerDelegate.h"
#import "OCMock.h"

@interface VPNManagerTests : SenTestCase
{
    VPNCDManager* manager;
    id delegate;
    id observer;
    VPNUser* user;
    
    NSString* receivedJSON;
    APICallType* receivedAPICall;
}

@end
