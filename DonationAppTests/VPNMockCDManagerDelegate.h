//
//  VPNMockCDManagerDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNCDManagerDelegate.h"
#import "VPNUser.h"

@interface VPNMockCDManagerDelegate : NSObject <VPNCDManagerDelegate>

@property (strong) NSError* fetchError;
@property (strong) VPNUser* receivedUser;
@property (strong) VPNSession* receivedSession;

-(void) startingSessionFailedWithError:(NSError*)error;
-(void) didStartSession:(VPNSession*)session;
-(void) didGetUser:(VPNUser*)user;
@end
