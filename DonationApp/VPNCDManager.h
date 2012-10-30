//
//  VPNCDManager.h
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNCDManagerDelegate.h"
#import "VPNCDCommunicator.h"
#import "VPNUserBuilder.h"

extern NSString* VPNCDManagerError;

enum {
    VPNCDManagerErrorStartSessionCode
};

@interface VPNCDManager : NSObject

@property (nonatomic, weak) id<VPNCDManagerDelegate> delegate;
@property (strong, nonatomic) VPNCDCommunicator* communicator;
@property (strong, nonatomic) VPNUserBuilder* userBuilder;

-(void)startSessionForUser:(VPNUser*)user;
-(void)startSessionForUserFailedWithError:(NSError*)error;
-(void)receivedUserJSON:(NSString*)objectNotation;


@end
