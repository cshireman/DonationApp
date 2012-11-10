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
#import "VPNCommunicatorDelegate.h"
#import "VPNUserBuilder.h"
#import "VPNSessionBuilder.h"
#import "VPNSession.h"

extern NSString* VPNCDManagerError;
extern NSString* APIErrorDomain;

enum {
    VPNCDManagerErrorStartSessionCode,
    VPNCDManagerInvalidUserError,
    VPNCDManagerInvalidJSONError,
};

enum {
    InvalidAPIKeyError = 1,
    InvalidSessionError = 2,
    InvalidUsernameOrPasswordError = 3,
    InvalidArgumentError = 4,
    DataNotFoundError = 5,
    YearNotAvailableError = 6,
    InvalidPromoCodeError = 7,
    EmailNotValidatedError = 9,
    AccountLimitError = 10,
    DuplicateUsernameError = 11
};

@interface VPNCDManager : NSObject <VPNCommunicatorDelegate>

@property (nonatomic, weak) id<VPNCDManagerDelegate> delegate;
@property (strong, nonatomic) VPNCDCommunicator* communicator;
@property (strong, nonatomic) VPNUserBuilder* userBuilder;
@property (strong, nonatomic) VPNSessionBuilder* sessionBuilder;

-(void)startSessionForUser:(VPNUser*)user;
-(void)startSessionForUserFailedWithError:(NSError*)error;

-(void)getUserInfo:(BOOL)forceDownload;
-(void)getOrganizations:(BOOL)forceDownload;

//Communicator delegate
-(void) receivedResponse:(NSString*)response forAPICall:(APICallType*)apiCall;
-(void) receivedError:(NSError*)error forAPICall:(APICallType*)apiCall;

@end
