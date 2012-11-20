//
//  VPNCDManagerDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNUser.h"
#import "VPNSession.h"

@protocol VPNCDManagerDelegate <NSObject>

@optional
//LoginUser
-(void) startingSessionFailedWithError:(NSError*)error;
-(void) didStartSession;

//GetUser
-(void) didGetUser:(VPNUser*)user;
-(void) getUserInfoFailedWithError:(NSError*)error;

//GetYears
-(void) didGetTaxYears:(NSArray*)taxYears;
-(void) getTaxYearsFailedWithError:(NSError*)error;

//GetOrganizations
-(void) didGetOrganizations:(NSArray*)organizations;
-(void) getOrganizationsFailedWithError:(NSError*)error;

//ChangePassword
-(void) didChangePassword;
-(void) changePasswordFailedWithError:(NSError*)error;

//UpdateUserInfo
-(void) didUpdateUserInfo;
-(void) updateUserInfoFailedWithError:(NSError*)error;


@end
