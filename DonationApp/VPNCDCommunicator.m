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
@synthesize currentConnection;
@synthesize delegate;
@synthesize handle;

-(id) init
{
    self = [super init];
    if(self)
    {
        validAPICalls = [[NSMutableArray alloc] initWithObjects:LoginUser,
                         LogoutUser,
                         RegisterTrialUser,
                         GetUserInfo,
                         UpdateUserInfo,
                         ChangePassword,
                         GetYears,
                         GetPurchaseOptions,
                         ValidatePromoCode,
                         AddPurchasedYear,
                         GetOrganizations,
                         AddOrganization,
                         UpdateOrganization,
                         DeleteOrganization,
                         GetItemLists,
                         GetCashLists,
                         GetMileageLists,
                         AddList,
                         UpdateList,
                         DeleteList,
                         AddListItem,
                         UpdateListItem,
                         DeleteListItem,
                         GetCategoryList,
                         SendDonationListReportWithValues,
                         SendItemizedSummaryReport,
                         SendTaxPrepSummaryReport,
                         nil];
        
    }
    
    return self;
}

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

-(void) makeAPICall:(NSString *)apiCall withContent:(NSString *)content
{
    if(apiCall == nil || ![validAPICalls containsObject:apiCall])
    {
        NSError* error = [NSError errorWithDomain:CommunicatorDomain code:CommunicatorInvalidAPICallError userInfo:nil];
        [delegate receivedError:error forAPICall:apiCall];
    }
    
    saveDataToDisc = NO;
    
    if([GetCategoryList isEqualToString:apiCall])
    {
        saveDataToDisc = YES;
        [[NSData data] writeToFile:[self dataFilePath] options:NSDataWritingAtomic error:nil];
        self.handle = [NSFileHandle fileHandleForUpdatingAtPath:[self dataFilePath]];
    }
    
    NSString* apiURL = [NSString stringWithFormat:@"http://review.prointegrations.com/charitydeductions/www/api/json/%@",apiCall];
    
    NSData* requestData = [NSData dataWithBytes:[content UTF8String] length:[content length]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:apiURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    currentCallType = [apiCall copy];
    currentConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void) cancelCurrentAPICall
{
    
}

-(NSString*) dataFilePath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = @"data_download_file";
    
    return [documentsDirectory stringByAppendingPathComponent:filePath];
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(nil == receivedData)
        receivedData = [[NSMutableData alloc] init];
    
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(nil == receivedData)
        receivedData = [[NSMutableData alloc] init];
    
    if(saveDataToDisc)
    {
        [handle seekToEndOfFile];
        [handle writeData:data];
    }
    else
    {
        [receivedData appendData:data];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //read response into dictionary
    if(saveDataToDisc)
    {
        [handle closeFile];
        NSData* jsonData = [[NSData alloc] initWithContentsOfFile:[self dataFilePath]];
        [delegate receivedResponse:jsonData forAPICall:currentCallType];
    }
    else
    {
        [delegate receivedResponse:self.receivedData forAPICall:currentCallType];
    }
}

@end

APICallType* Idle = @"Idle";

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