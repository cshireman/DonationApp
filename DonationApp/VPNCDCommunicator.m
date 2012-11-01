//
//  VPNCDCommunicator.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNCDCommunicator.h"

@implementation VPNCDCommunicator
@synthesize receivedData;
@synthesize currentCallType;
@synthesize delegate;

-(void) setDelegate:(id<VPNCommunicatorDelegate>)newDelegate
{
    if(newDelegate && ![newDelegate conformsToProtocol:@protocol(VPNCommunicatorDelegate)])
    {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not conform to the delegate protocol" userInfo:nil] raise];
    }
    else
    {
        delegate = newDelegate;
    }
}

-(void)startSessionForUser:(VPNUser*)user
{
    NSParameterAssert(user != nil);
    
    if(user.username == nil || [user.username isEqualToString:@""])
    {
        NSError* error = [NSError errorWithDomain:CommunicatorDomain code:CommunicatorInvalidUserError userInfo:nil];
        [delegate receivedError:error];
    }
    
    currentCallType = LoginUser;
}


#pragma mark -
#pragma mark NSURLConnection Delegate Methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(nil == receivedData)
        receivedData = [[NSMutableData alloc] init];
    
    [receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //read response into dictionary
    NSString *jsonString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];	
}

@end

APICallType* LoginUser = @"LoginUser";
APICallType* LogoutUser = @"LogoutUser";
APICallType* RegisterTrialUser = @"RegisterTrialUser";
APICallType* GetUserInfo = @"GetUserInfo";
APICallType* UpdateUserInfo = @"UpdateUserInfo";

APICallType* ChangePassword = @"ChangePassword";
APICallType* GetYears = @"GetYears";
APICallType* GetPurchaseOptions = @"GetPurchaseOptions";
APICallType* ValidatePromoCode = @"ValidatePromoCode";
APICallType* AddPurchasedYear = @"AddPurchasedYear";

APICallType* GetOrganizations = @"GetOrganizations";
APICallType* AddOrganization = @"AddOrganization";
APICallType* UpdateOrganization = @"UpdateOrganization";
APICallType* DeleteOrganization = @"DeleteOrganization";

APICallType* GetItemLists = @"GetItemLists";
APICallType* GetCashLists = @"GetCashLists";
APICallType* GetMileageLists = @"GetMileageLists";

APICallType* AddList = @"AddList";
APICallType* UpdateList = @"UpdateList";
APICallType* DeleteList = @"DeleteList";

APICallType* AddListItem = @"AddListItem";
APICallType* UpdateListItem = @"UpdateListItem";
APICallType* DeleteListItem = @"DeleteListItem";

APICallType* GetCategoryList = @"GetCategoryList";
APICallType* SendDonationListReportWithValues = @"SendDonationListReportWithValues";
APICallType* SendItemizedSummaryReport = @"SendItemizedSummaryReport";
APICallType* SendTaxPrepSummaryReport = @"SendTaxPrepSummaryReport";

NSString* CommunicatorDomain = @"CommunicatorDomain";