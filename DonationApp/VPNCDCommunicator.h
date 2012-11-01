//
//  VPNCDCommunicator.h
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNCommunicatorDelegate.h"
#import "VPNUser.h"

typedef NSString APICallType;

extern APICallType* LoginUser;
extern APICallType* LogoutUser;
extern APICallType* RegisterTrialUser;
extern APICallType* GetUserInfo;
extern APICallType* UpdateUserInfo;

extern APICallType* ChangePassword;
extern APICallType* GetYears;
extern APICallType* GetPurchaseOptions;
extern APICallType* ValidatePromoCode;
extern APICallType* AddPurchasedYear;

extern APICallType* GetOrganizations;
extern APICallType* AddOrganization;
extern APICallType* UpdateOrganization;
extern APICallType* DeleteOrganization;

extern APICallType* GetItemLists;
extern APICallType* GetCashLists;
extern APICallType* GetMileageLists;

extern APICallType* AddList;
extern APICallType* UpdateList;
extern APICallType* DeleteList;

extern APICallType* AddListItem;
extern APICallType* UpdateListItem;
extern APICallType* DeleteListItem;

extern APICallType* GetCategoryList;
extern APICallType* SendDonationListReportWithValues;
extern APICallType* SendItemizedSummaryReport;
extern APICallType* SendTaxPrepSummaryReport;

extern NSString* CommunicatorDomain;

enum {
    CommunicatorInvalidUserError
};

@interface VPNCDCommunicator : NSObject <NSURLConnectionDataDelegate>

@property (strong) NSMutableData* receivedData;
@property (copy) APICallType* currentCallType;

@property (weak, nonatomic) id<VPNCommunicatorDelegate> delegate;
@property (strong) NSURLConnection* currentConnection;

-(void)startSessionForUser:(VPNUser*)user;
-(void)cancelCurrentConnection;

//NSURLConnectionDataDelegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
