//
//  VPNCDManager.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNCDManager.h"
#import "VPNItemList.h"
#import "VPNCashList.h"
#import "VPNMileageList.h"
#import "VPNCategoryList.h"

NSString* const APIKey = @"12C7DCE347154B5A8FD49B72F169A975";

@implementation VPNCDManager

@synthesize delegate;
@synthesize communicator;
@synthesize userBuilder;
@synthesize sessionBuilder;
@synthesize currentTaxYear;
@synthesize currentOrganization;

-(id) init
{
    self = [super init];
    if(self){
        communicator = [[VPNCDCommunicator alloc] init];
        communicator.delegate = self;
    }
    
    return self;
}

-(void) setDelegate:(id<VPNCDManagerDelegate>)newDelegate
{
    if(newDelegate && ![newDelegate conformsToProtocol:@protocol(VPNCDManagerDelegate)])
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
    if(user == nil || user.username == nil || user.password == nil)
    {
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidUserError userInfo:nil];
        
        [delegate startingSessionFailedWithError:error];
        return;
    }
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:user.username forKey:@"username"];
    [request setObject:user.password forKey:@"password"];
    [request setObject:@"" forKey:@"userAgent"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate startingSessionFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [communicator makeAPICall:LoginUser withContent:jsonString];
}

-(void) getUserInfo:(BOOL)forceDownload
{
    VPNUser* user = nil;
    
    if(!forceDownload)
    {
        user = [VPNUser loadUserFromDisc];
    }
    
    if(user == nil)
    {
        NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
        VPNSession* session = [VPNSession currentSession];
        NSLog(@"Session:%@",session.session);
        
        [request setObject:APIKey forKey:@"apiKey"];
        [request setObject:session.session forKey:@"session"];
        
        NSError* error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
        
        if(error != nil)
        {
            NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:error forKey:NSUnderlyingErrorKey];
            NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
            
            [delegate getUserInfoFailedWithError:error];
            return;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [communicator makeAPICall:GetUserInfo withContent:jsonString];
    }
    else
    {
        [delegate didGetUser:user];
    }
}

-(void) getOrganizations:(BOOL)forceDownload
{
    NSMutableArray* organizations = nil;
    
    if(!forceDownload)
    {
        organizations = [VPNOrganization loadOrganizationsFromDisc];
    }
    
    if(organizations == nil)
    {
        NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
        VPNSession* session = [VPNSession currentSession];
        
        [request setObject:APIKey forKey:@"apiKey"];
        [request setObject:session.session forKey:@"session"];
        [request setObject:[NSNumber numberWithBool:YES] forKey:@"includeInactive"];
        
        NSError* error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
        
        if(error != nil)
        {
            NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:error forKey:NSUnderlyingErrorKey];
            NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
            
            [delegate getOrganizationsFailedWithError:error];
            return;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [communicator makeAPICall:GetOrganizations withContent:jsonString];
    }
    else
    {
        [delegate didGetOrganizations:organizations];
    }
    
}

-(void)addOrganization:(VPNOrganization*)organization
{
    NSParameterAssert(organization != nil);
    NSParameterAssert(organization.ID == 0);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* orgInfo = [[NSMutableDictionary alloc] init];
    
    VPNSession* session = [VPNSession currentSession];
    
    [organization fillWithBlanks];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    
    [orgInfo setObject:organization.name forKey:@"name"];
    [orgInfo setObject:organization.address forKey:@"address1"];
    [orgInfo setObject:organization.city forKey:@"city"];
    [orgInfo setObject:organization.state forKey:@"state"];
    [orgInfo setObject:organization.zip_code forKey:@"zip"];
    
    [orgInfo setObject:@"" forKey:@"address2"];
    [orgInfo setObject:@"" forKey:@"phone"];
    [orgInfo setObject:@"" forKey:@"fax"];

    [request setObject:orgInfo forKey:@"organization"];

    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate addOrganizationFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.currentOrganization = organization;
    [communicator makeAPICall:AddOrganization withContent:jsonString];
}

-(void)updateOrganization:(VPNOrganization*)organization
{
    NSParameterAssert(organization != nil);
    NSParameterAssert(organization.ID != 0);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* orgInfo = [[NSMutableDictionary alloc] init];
    
    VPNSession* session = [VPNSession currentSession];
    
    [organization fillWithBlanks];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    
    [orgInfo setObject:organization.name forKey:@"name"];
    [orgInfo setObject:organization.address forKey:@"address1"];
    [orgInfo setObject:organization.city forKey:@"city"];
    [orgInfo setObject:organization.state forKey:@"state"];
    [orgInfo setObject:organization.zip_code forKey:@"zip"];
    
    [orgInfo setObject:@"" forKey:@"address2"];
    [orgInfo setObject:@"" forKey:@"phone"];
    [orgInfo setObject:@"" forKey:@"fax"];
    
    [request setObject:[NSString stringWithFormat:@"%d",organization.ID] forKey:@"id"];
    [request setObject:orgInfo forKey:@"organization"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate updateOrganizationFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.currentOrganization = organization;
    [communicator makeAPICall:UpdateOrganization withContent:jsonString];
    
}

-(void)deleteOrganization:(VPNOrganization*)organization
{
    NSParameterAssert(organization != nil);
    NSParameterAssert(organization.ID != 0);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    
    VPNSession* session = [VPNSession currentSession];
    
    [organization fillWithBlanks];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    [request setObject:[NSString stringWithFormat:@"%d",organization.ID] forKey:@"id"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate deleteOrganizationFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.currentOrganization = organization;
    [communicator makeAPICall:DeleteOrganization withContent:jsonString];
    
}

-(void)getTaxYears:(BOOL)forceDownload
{
    NSMutableArray* taxYears = nil;
    
    if(!forceDownload)
    {
        taxYears = [VPNUser currentUser].tax_years;
    }
    
    if(taxYears == nil)
    {
        NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
        VPNSession* session = [VPNSession currentSession];
        
        [request setObject:APIKey forKey:@"apiKey"];
        [request setObject:session.session forKey:@"session"];
        
        NSError* error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
        
        if(error != nil)
        {
            NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:error forKey:NSUnderlyingErrorKey];
            NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
            
            [delegate getTaxYearsFailedWithError:error];
            return;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [communicator makeAPICall:GetYears withContent:jsonString];
    }
    else
    {
        [delegate didGetTaxYears:taxYears];
    }    
}

-(void)changePassword:(NSString*)newPassword
{
    NSParameterAssert(newPassword != nil);
    NSParameterAssert(![newPassword isEqualToString:@""]);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    VPNSession* session = [VPNSession currentSession];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    [request setObject:newPassword forKey:@"newPassword"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate changePasswordFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [communicator makeAPICall:ChangePassword withContent:jsonString];
}

-(void)updateUserInfo:(VPNUser*)user
{
    NSParameterAssert(user != nil);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    VPNSession* session = [VPNSession currentSession];
    
    [user fillWithBlanks];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    
    [request setObject:user.first_name forKey:@"firstName"];
    [request setObject:user.last_name forKey:@"lastName"];
    [request setObject:user.phone forKey:@"phone"];
    [request setObject:user.email forKey:@"email"];
    [request setObject:user.company forKey:@"company"];
    
    [request setObject:user.address1 forKey:@"address1"];
    [request setObject:user.address2 forKey:@"address2"];
    [request setObject:user.city forKey:@"city"];
    [request setObject:user.state forKey:@"state"];
    [request setObject:user.zip forKey:@"zip"];
    
    if(user.is_email_opted_in)
        [request setObject:[NSNumber numberWithInt:0] forKey:@"emailOptOut"];
    else
        [request setObject:[NSNumber numberWithInt:1] forKey:@"emailOptOut"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate changePasswordFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [communicator makeAPICall:UpdateUserInfo withContent:jsonString];
    
}

-(void)getItemListsForTaxYear:(int)taxYear forceDownload:(BOOL)forceDownload
{
    NSMutableArray* itemLists = nil;
    currentTaxYear = taxYear;
    
    if(!forceDownload)
    {
        itemLists = [VPNItemList loadItemListsFromDisc:taxYear];
    }
    
    if(itemLists == nil)
    {
        NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
        VPNSession* session = [VPNSession currentSession];
        
        [request setObject:APIKey forKey:@"apiKey"];
        [request setObject:session.session forKey:@"session"];
        [request setObject:[NSNumber numberWithInt:taxYear] forKey:@"year"];
        
        NSError* error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
        
        if(error != nil)
        {
            NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:error forKey:NSUnderlyingErrorKey];
            NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
            
            [delegate getItemListsFailedWithError:error];
            return;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [communicator makeAPICall:GetItemLists withContent:jsonString];
    }
    else
    {
        [delegate didGetItemLists:itemLists];
    }
    
}

-(void)getCashListsForTaxYear:(int)taxYear forceDownload:(BOOL)forceDownload
{
    NSMutableArray* cashLists = nil;
    currentTaxYear = taxYear;
    
    if(!forceDownload)
    {
        cashLists = [VPNCashList loadCashListsFromDisc:taxYear];
    }
    
    if(cashLists == nil)
    {
        NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
        VPNSession* session = [VPNSession currentSession];
        
        [request setObject:APIKey forKey:@"apiKey"];
        [request setObject:session.session forKey:@"session"];
        [request setObject:[NSNumber numberWithInt:taxYear] forKey:@"year"];
        
        NSError* error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
        
        if(error != nil)
        {
            NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:error forKey:NSUnderlyingErrorKey];
            NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
            
            [delegate getItemListsFailedWithError:error];
            return;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [communicator makeAPICall:GetCashLists withContent:jsonString];
    }
    else
    {
        [delegate didGetCashLists:cashLists];
    }
    
}

-(void)getMileageListsForTaxYear:(int)taxYear forceDownload:(BOOL)forceDownload
{
    NSMutableArray* mileageLists = nil;
    currentTaxYear = taxYear;
    
    if(!forceDownload)
    {
        mileageLists = [VPNMileageList loadMileageListsFromDisc:taxYear];
    }
    
    if(mileageLists == nil)
    {
        NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
        VPNSession* session = [VPNSession currentSession];
        
        [request setObject:APIKey forKey:@"apiKey"];
        [request setObject:session.session forKey:@"session"];
        [request setObject:[NSNumber numberWithInt:taxYear] forKey:@"year"];
        
        NSError* error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
        
        if(error != nil)
        {
            NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:error forKey:NSUnderlyingErrorKey];
            NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
            
            [delegate getMileageListsFailedWithError:error];
            return;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [communicator makeAPICall:GetMileageLists withContent:jsonString];
    }
    else
    {
        [delegate didGetMileageLists:mileageLists];
    }    
}

-(void)getCategoryListForTaxYear:(int)taxYear forceDownload:(BOOL)forceDownload
{
    NSDictionary* categoryList = nil;
    currentTaxYear = taxYear;
    
    if(!forceDownload)
    {
        categoryList = nil;//[VPNCategoryList loadCategoryListsFromDisc:taxYear];
    }
    
    if(categoryList == nil)
    {
        NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
        VPNSession* session = [VPNSession currentSession];
        
        [request setObject:APIKey forKey:@"apiKey"];
        [request setObject:session.session forKey:@"session"];
        [request setObject:[NSNumber numberWithInt:taxYear] forKey:@"year"];
        
        NSError* error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
        
        if(error != nil)
        {
            NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:error forKey:NSUnderlyingErrorKey];
            NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
            
            [delegate getCategoryListFailedWithError:error];
            return;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [communicator makeAPICall:GetCategoryList withContent:jsonString];
    }
    else
    {
        [delegate didGetCategoryList:categoryList];
    }
}



#pragma mark -
#pragma mark Communicator Delegate Methods

-(void) receivedResponse:(NSString*)response forAPICall:(APICallType*)apiCall
{

    if(response == nil)
    {
        NSError* jsonError = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerErrorStartSessionCode userInfo:nil];
        
        [delegate startingSessionFailedWithError:jsonError];
        return;
    }
    
    NSError* error = nil;
    NSData* responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* responseInfo = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    
    if(error == nil)
    {
        NSDictionary* d = [responseInfo objectForKey:@"d"];
        
        if([@"SUCCESS" isEqualToString:[d objectForKey:@"status"]])
        {
            //Take action based on api call
            if([LoginUser isEqual:apiCall])
            {
                VPNSession* session = [VPNSession currentSession];
                if(session == nil)
                    session = [[VPNSession alloc] init];
                
                [session populateWithDictionary:d];
                
                [VPNSession setCurrentSessionWithSession:session];
                
                [delegate didStartSession];
            }
            else if([GetUserInfo isEqual:apiCall])
            {
                VPNUser* currentUser = [VPNUser currentUser];
                [currentUser populateWithDictionary:[d objectForKey:@"user"]];
                [VPNUser saveUserToDisc:currentUser];
                
                [delegate didGetUser:currentUser];
            }
            else if([GetOrganizations isEqual:apiCall])
            {
                NSArray* resultOrgs = [d objectForKey:@"organizations"];
                if(nil != resultOrgs && [resultOrgs count] > 0)
                {
                    NSMutableArray* organizations = [[NSMutableArray alloc] initWithCapacity:[resultOrgs count]];
                    for(NSDictionary* orgInfo in resultOrgs)
                    {
                        [organizations addObject:[[VPNOrganization alloc] initWithDictionary:orgInfo]];
                    }
                    
                    [VPNOrganization saveOrganizationsToDisc:organizations];
                    [delegate didGetOrganizations:organizations];
                }
                else
                {
                    [delegate didGetOrganizations:[NSArray array]];
                }
            }
            else if([AddOrganization isEqualToString:apiCall])
            {
                NSNumber* newOrgID = [d objectForKey:@"id"];
                self.currentOrganization.ID = [newOrgID intValue];
                
                [delegate didAddOrganization:self.currentOrganization];
            }
            else if([UpdateOrganization isEqualToString:apiCall])
            {
                [delegate didUpdateOrganization:self.currentOrganization];
            }
            else if([DeleteOrganization isEqualToString:apiCall])
            {
                [delegate didDeleteOrganization];
            }
            else if([GetYears isEqualToString:apiCall])
            {
                NSArray* resultYears = [d objectForKey:@"years"];
                if(nil != resultYears && [resultYears count] > 0)
                {
                    [VPNUser currentUser].tax_years = [NSMutableArray arrayWithArray:resultYears];
                    [[VPNUser currentUser] saveAsDefaultUser];
                    
                    [delegate didGetTaxYears:resultYears];
                }
                else
                {
                    [delegate didGetTaxYears:[NSArray array]];
                }                
            }
            else if([ChangePassword isEqualToString:apiCall])
            {
                [delegate didChangePassword];
            }
            else if([UpdateUserInfo isEqualToString:apiCall])
            {
                [delegate didUpdateUserInfo];
            }
            else if([GetItemLists isEqualToString:apiCall])
            {
                NSArray* resultLists = [d objectForKey:@"lists"];
                if(nil != resultLists && [resultLists count] > 0)
                {
                    NSMutableArray* lists = [[NSMutableArray alloc] initWithCapacity:[resultLists count]];
                    for(NSDictionary* listInfo in resultLists)
                    {
                        [lists addObject:[[VPNItemList alloc] initWithDictionary:listInfo]];
                    }
                    
                    [VPNItemList saveItemListsToDisc:lists forTaxYear:currentTaxYear];
                    [delegate didGetItemLists:lists];
                }
                else
                {
                    [delegate didGetItemLists:[NSArray array]];
                }
            }
            else if([GetCashLists isEqualToString:apiCall])
            {
                NSArray* resultLists = [d objectForKey:@"lists"];
                if(nil != resultLists && [resultLists count] > 0)
                {
                    NSMutableArray* lists = [[NSMutableArray alloc] initWithCapacity:[resultLists count]];
                    for(NSDictionary* listInfo in resultLists)
                    {
                        [lists addObject:[[VPNCashList alloc] initWithDictionary:listInfo]];
                    }
                    
                    [VPNCashList saveCashListsToDisc:lists forTaxYear:currentTaxYear];
                    [delegate didGetCashLists:lists];
                }
                else
                {
                    [delegate didGetCashLists:[NSArray array]];
                }
            }
            else if([GetMileageLists isEqualToString:apiCall])
            {
                NSArray* resultLists = [d objectForKey:@"lists"];
                if(nil != resultLists && [resultLists count] > 0)
                {
                    NSMutableArray* lists = [[NSMutableArray alloc] initWithCapacity:[resultLists count]];
                    for(NSDictionary* listInfo in resultLists)
                    {
                        [lists addObject:[[VPNMileageList alloc] initWithDictionary:listInfo]];
                    }
                    
                    [VPNMileageList saveMileageListsToDisc:lists forTaxYear:currentTaxYear];
                    [delegate didGetMileageLists:lists];
                }
                else
                {
                    [delegate didGetMileageLists:[NSArray array]];
                }
            }
            else if([GetCategoryList isEqualToString:apiCall])
            {
                NSArray* resultLists = [d objectForKey:@"categories"];
                if(nil != resultLists && [resultLists count] > 0)
                {
                    [delegate didGetCategoryList:d];
                }
                else
                {
                    [delegate didGetCategoryList:[NSDictionary dictionary]];
                }
            }
        }
        else
        {
            //create error and send to appropriate delegate method
            NSInteger apiErrorCode = [[d objectForKey:@"errorCode"] integerValue];
            NSDictionary* errorInfo = [NSDictionary dictionaryWithObject:[d objectForKey:@"errorMessage"] forKey:@"errorMessage"];
            
            NSError* apiError = [NSError errorWithDomain:APIErrorDomain code:apiErrorCode userInfo:errorInfo];
            
            if([LoginUser isEqual:apiCall])
                [delegate startingSessionFailedWithError:apiError];
            else if([GetUserInfo isEqual:apiCall])
                [delegate getUserInfoFailedWithError:apiError];
            else if([GetOrganizations isEqual:apiCall])
                [delegate getOrganizationsFailedWithError:apiError];
            else if([AddOrganization isEqual:apiCall])
                [delegate addOrganizationFailedWithError:apiError];
            else if([UpdateOrganization isEqual:apiCall])
                [delegate updateOrganizationFailedWithError:apiError];
            else if([DeleteOrganization isEqual:apiCall])
                [delegate deleteOrganizationFailedWithError:apiError];
            else if([ChangePassword isEqualToString:apiCall])
                [delegate changePasswordFailedWithError:apiError];
            else if([UpdateUserInfo isEqualToString:apiCall])
                [delegate updateUserInfoFailedWithError:apiError];
            else if([GetItemLists isEqualToString:apiCall])
                [delegate getItemListsFailedWithError:apiError];
            else if([GetCashLists isEqualToString:apiCall])
                [delegate getCashListsFailedWithError:apiError];
            else if([GetMileageLists isEqualToString:apiCall])
                [delegate getMileageListsFailedWithError:apiError];
            else if([GetCategoryList isEqualToString:apiCall])
                [delegate getCategoryListFailedWithError:apiError];
            
        }
    }
    else
    {
        NSError* jsonError = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:nil];
        
        if([LoginUser isEqual:apiCall])
            [delegate startingSessionFailedWithError:jsonError];
        else if([GetUserInfo isEqual:apiCall])
            [delegate getUserInfoFailedWithError:jsonError];
        else if([GetOrganizations isEqual:apiCall])
            [delegate getOrganizationsFailedWithError:jsonError];
        else if([AddOrganization isEqual:apiCall])
            [delegate addOrganizationFailedWithError:jsonError];
        else if([UpdateOrganization isEqual:apiCall])
            [delegate updateOrganizationFailedWithError:jsonError];
        else if([DeleteOrganization isEqual:apiCall])
            [delegate deleteOrganizationFailedWithError:jsonError];
        else if([ChangePassword isEqualToString:apiCall])
            [delegate changePasswordFailedWithError:jsonError];
        else if([UpdateUserInfo isEqualToString:apiCall])
            [delegate updateUserInfoFailedWithError:jsonError];
        else if([GetItemLists isEqualToString:apiCall])
            [delegate getItemListsFailedWithError:jsonError];
        else if([GetCashLists isEqualToString:apiCall])
            [delegate getCashListsFailedWithError:jsonError];
        else if([GetMileageLists isEqualToString:apiCall])
            [delegate getMileageListsFailedWithError:jsonError];
        else if([GetCategoryList isEqualToString:apiCall])
            [delegate getCategoryListFailedWithError:jsonError];
    }
}

-(void) receivedError:(NSError*)error forAPICall:(APICallType*)apiCall
{
    if([LoginUser isEqual:apiCall])
        [delegate startingSessionFailedWithError:error];
    else if([GetUserInfo isEqual:apiCall])
        [delegate getUserInfoFailedWithError:error];
    else if([GetOrganizations isEqual:apiCall])
        [delegate getOrganizationsFailedWithError:error];
    else if([AddOrganization isEqual:apiCall])
        [delegate addOrganizationFailedWithError:error];
    else if([UpdateOrganization isEqual:apiCall])
        [delegate updateOrganizationFailedWithError:error];
    else if([DeleteOrganization isEqual:apiCall])
        [delegate deleteOrganizationFailedWithError:error];
    else if([GetYears isEqual:apiCall])
        [delegate getTaxYearsFailedWithError:error];
    else if([ChangePassword isEqual:apiCall])
        [delegate changePasswordFailedWithError:error];
    else if([UpdateUserInfo isEqualToString:apiCall])
        [delegate updateUserInfoFailedWithError:error];
    else if([GetItemLists isEqualToString:apiCall])
        [delegate getItemListsFailedWithError:error];
    else if([GetCashLists isEqualToString:apiCall])
        [delegate getCashListsFailedWithError:error];
    else if([GetMileageLists isEqualToString:apiCall])
        [delegate getMileageListsFailedWithError:error];
    else if([GetCategoryList isEqualToString:apiCall])
        [delegate getCategoryListFailedWithError:error];
    
}


@end

NSString* VPNCDManagerError = @"VPNCDManagerError";
NSString* APIErrorDomain = @"APIErrorDomain";
