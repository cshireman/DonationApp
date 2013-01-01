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
//Idle
-(void) didIdle;
-(void) idleFailedWithError:(NSError*)error;

//LoginUser
-(void) startingSessionFailedWithError:(NSError*)error;
-(void) didStartSession;

//RegisterTrialUser
-(void) didRegisterTrialUser:(VPNUser*)user;
-(void) registerTrialUserFailedWithError:(NSError*)error;

//GetUser
-(void) didGetUser:(VPNUser*)user;
-(void) getUserInfoFailedWithError:(NSError*)error;

//GetYears
-(void) didGetTaxYears:(NSArray*)taxYears;
-(void) getTaxYearsFailedWithError:(NSError*)error;

//GetPurchaseOptions
-(void) didGetPurchaseOptions:(NSDictionary*)info;
-(void) getPurchaseOptionsFailedWithError:(NSError*)error;

//ValidatePromoCode
-(void) didValidatePromoCode:(NSDictionary*)info;
-(void) validatePromoCodeFailedWithError:(NSError*)error;

//AddPurchasedYear
-(void) didAddPurchasedYear:(NSDictionary*)info;
-(void) addPurchasedYearFailedWithError:(NSError*)error;

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

//AddList
-(void) didAddList:(id)list;
-(void) addListFailedWithError:(NSError*)error;

//UpdateList
-(void) didUpdateList:(id)list;
-(void) updateListFailedWithError:(NSError*)error;

//AddListItem
-(void) didAddListItem:(id)item;
-(void) addListItemFailedWithError:(NSError*)error;

//UpdateListItem
-(void) didUpdateListItem:(id)item;
-(void) updateListItemFailedWithError:(NSError*)error;

//DeleteListItem
-(void) didDeleteListItem:(id)item;
-(void) deleteListItemFailedWithError:(NSError*)error;

//SendItemizedSummaryReport
-(void) didSendItemizedSummaryReport;
-(void) sendItemizedSummaryReportFailedWithError:(NSError*)error;

//SendTextSummaryReport
-(void) didSendTaxPrepSummaryReport;
-(void) sendTaxPrepSummaryReportFailedWithError:(NSError*)error;

//SendItemizedSummaryReport
-(void) didSendDonationListReportWithValues;
-(void) sendDonationListReportWithValuesFailedWithError:(NSError*)error;



@end
