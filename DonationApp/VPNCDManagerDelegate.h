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
#import "VPNOrganization.h"

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

//AddOrganization
-(void) didAddOrganization:(VPNOrganization*)addedOrganization;
-(void) addOrganizationFailedWithError:(NSError*)error;

//UpdateOrganization
-(void) didUpdateOrganization:(VPNOrganization*)updatedOrganization;
-(void) updateOrganizationFailedWithError:(NSError*)error;

//DeleteOrganization
-(void) didDeleteOrganization;
-(void) deleteOrganizationFailedWithError:(NSError*)error;

//ChangePassword
-(void) didChangePassword;
-(void) changePasswordFailedWithError:(NSError*)error;

//UpdateUserInfo
-(void) didUpdateUserInfo;
-(void) updateUserInfoFailedWithError:(NSError*)error;

//GetItemLists
-(void) didGetItemLists:(NSArray*)itemLists;
-(void) getItemListsFailedWithError:(NSError*)error;

//GetCashLists
-(void) didGetCashLists:(NSArray*)cashLists;
-(void) getCashListsFailedWithError:(NSError*)error;

//GetMileageLists
-(void) didGetMileageLists:(NSArray*)mileageLists;
-(void) getMileageListsFailedWithError:(NSError*)error;

//GetCategoryList
-(void) didGetCategoryList:(NSArray*)categoryList;
-(void) getCategoryListFailedWithError:(NSError*)error;

//DeleteList
-(void) didDeleteList:(id)list;
-(void) deleteListFailedWithError:(NSError*)error;


@end
