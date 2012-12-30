//
//  VPNCDManager.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNCDManager.h"
#import "VPNNotifier.h"
#import "VPNItemList.h"
#import "VPNCashList.h"
#import "VPNMileageList.h"
#import "VPNAppDelegate.h"
#import "Category.h"
#import "Category+JSONParser.h"

NSString* const APIKey = @"12C7DCE347154B5A8FD49B72F169A975";

@implementation VPNCDManager

@synthesize delegate;
@synthesize communicator;
@synthesize userBuilder;
@synthesize sessionBuilder;
@synthesize currentTaxYear;
@synthesize currentOrganization;
@synthesize currentDonationList;
@synthesize currentListItem;
@synthesize currentUser;

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

-(void)startSessionForUserFailedWithError:(NSError*)error
{
    
}

-(void)registerTrialUser:(VPNUser*)trialUser withTaxYear:(int)taxYear
{
    if(trialUser == nil || trialUser.username == nil || trialUser.password == nil)
    {
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidUserError userInfo:nil];
        
        [delegate registerTrialUserFailedWithError:error];
        return;
    }
    
    currentUser = trialUser;
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:trialUser.username forKey:@"username"];
    [request setObject:trialUser.password forKey:@"password"];
    [request setObject:trialUser.first_name forKey:@"firstName"];
    [request setObject:trialUser.last_name forKey:@"lastName"];

    [request setObject:@"" forKey:@"company"];
    [request setObject:trialUser.email forKey:@"email"];
    [request setObject:[NSNumber numberWithInt:taxYear] forKey:@"year"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate registerTrialUserFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [communicator makeAPICall:RegisterTrialUser withContent:jsonString];
    
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

-(void)addDonationList:(VPNDonationList*)listToAdd
{
    NSParameterAssert(listToAdd != nil);
    NSParameterAssert(listToAdd.ID == 0);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    
    VPNSession* session = [VPNSession currentSession];
    VPNUser* user = [VPNUser currentUser];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    [request setObject:[NSNumber numberWithInt:user.selected_tax_year] forKey:@"year"];
    [request setObject:[NSNumber numberWithInt:listToAdd.listType] forKey:@"listType"];
    
    NSDictionary* listInfo = [listToAdd toDictionary];
    NSLog(@"List Info: %@",listInfo);
    [request setObject:listInfo forKey:@"list"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate addListFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Request: %@",jsonString);
    self.currentDonationList = listToAdd;
    [communicator makeAPICall:AddList withContent:jsonString];
}

-(void)updateDonationList:(VPNDonationList*)listToUpdate
{
    NSParameterAssert(listToUpdate != nil);
    NSParameterAssert(listToUpdate.ID != 0);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    
    VPNSession* session = [VPNSession currentSession];    
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    [request setObject:[NSString stringWithFormat:@"%d",listToUpdate.ID] forKey:@"id"];
    
    [request setObject:[listToUpdate toDictionary] forKey:@"list"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate updateListFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.currentDonationList = listToUpdate;
    [communicator makeAPICall:UpdateList withContent:jsonString];
}


-(void)deleteDonationList:(VPNDonationList*)listToDelete
{
    NSParameterAssert(listToDelete != nil);
    NSParameterAssert(listToDelete.ID != 0);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    
    VPNSession* session = [VPNSession currentSession];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    [request setObject:[NSString stringWithFormat:@"%d",listToDelete.ID] forKey:@"id"];
    
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
    
    self.currentDonationList = listToDelete;
    [communicator makeAPICall:DeleteList withContent:jsonString];
    
}

-(void)addDonationListItem:(VPNItem*)itemToAdd toDonationList:(VPNDonationList*)donationList
{
    NSParameterAssert(itemToAdd != nil);
    NSParameterAssert(itemToAdd.ID == 0);
    
    NSParameterAssert(donationList != nil);
    NSParameterAssert(donationList.ID != 0);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    
    VPNSession* session = [VPNSession currentSession];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    [request setObject:[NSNumber numberWithInt:donationList.ID] forKey:@"listID"];
    
    NSDictionary* itemInfo = [itemToAdd toDictionary];
    [request setObject:itemInfo forKey:@"item"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate addListItemFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Request: %@",jsonString);
    
    self.currentListItem = itemToAdd;
    self.currentDonationList = donationList;
    
    [communicator makeAPICall:AddListItem withContent:jsonString];
    
}

-(void)updateDonationListItem:(VPNItem*)itemToUpdate onDonationList:(VPNDonationList*)donationList
{
    NSParameterAssert(itemToUpdate != nil);
    NSParameterAssert(itemToUpdate.ID != 0);
    
    NSParameterAssert(donationList != nil);
    NSParameterAssert(donationList.ID != 0);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    
    VPNSession* session = [VPNSession currentSession];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    [request setObject:[NSNumber numberWithInt:donationList.ID] forKey:@"listID"];
    [request setObject:[NSNumber numberWithInt:itemToUpdate.ID] forKey:@"id"];
    
    NSDictionary* itemInfo = [itemToUpdate toDictionary];
    [request setObject:itemInfo forKey:@"item"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate updateListItemFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Request: %@",jsonString);
    
    self.currentListItem = itemToUpdate;
    self.currentDonationList = donationList;
    
    [communicator makeAPICall:UpdateListItem withContent:jsonString];
    
}

-(void)deleteDonationListItem:(VPNItem*)itemToDelete fromDonationList:(VPNDonationList*)donationList
{
    NSParameterAssert(itemToDelete != nil);
    NSParameterAssert(itemToDelete.ID != 0);
    
    NSParameterAssert(donationList != nil);
    NSParameterAssert(donationList.ID != 0);
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    
    VPNSession* session = [VPNSession currentSession];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    [request setObject:[NSString stringWithFormat:@"%d",itemToDelete.ID] forKey:@"id"];
    [request setObject:[NSString stringWithFormat:@"%d",donationList.ID] forKey:@"listID"];
    
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
    
    self.currentListItem = itemToDelete;
    self.currentDonationList = donationList;
    
    [communicator makeAPICall:DeleteListItem withContent:jsonString];
    
}

-(void)getCategoryListForTaxYear:(int)taxYear forceDownload:(BOOL)forceDownload
{
    NSArray* categoryList = nil;
    currentTaxYear = taxYear;
    
    if(!forceDownload)
    {
        NSArray* categories = [Category getByTaxYear:taxYear];
        if(categories == nil)
        {
            NSLog(@"There was an error");
            [delegate getCategoryListFailedWithError:nil];
        }
        
        if([categories count] > 0)
        {
            [delegate didGetCategoryList:categories];
            return;
        }
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

-(void)sendItemizedSummaryReport:(int)taxYear
{
    currentTaxYear = taxYear;
    
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
        
        [delegate sendItemizedSummaryReportFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Request: %@",jsonString);
    [communicator makeAPICall:SendItemizedSummaryReport withContent:jsonString];
}

-(void)sendTaxPrepSummaryReport:(int)taxYear
{
    currentTaxYear = taxYear;
    
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
        
        [delegate sendTaxPrepSummaryReportFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Request: %@",jsonString);
    
    [communicator makeAPICall:SendTaxPrepSummaryReport withContent:jsonString];
    
}

-(void)sendDonationListReportWithValues:(VPNDonationList*)donationList
{
    currentDonationList = donationList;
    
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    VPNSession* session = [VPNSession currentSession];
    
    [request setObject:APIKey forKey:@"apiKey"];
    [request setObject:session.session forKey:@"session"];
    [request setObject:[NSNumber numberWithInt:donationList.ID] forKey:@"listID"];
    [request setObject:[NSNumber numberWithInt:1] forKey:@"includeValues"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if(error != nil)
    {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
        NSError* error = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:userInfo];
        
        [delegate sendDonationListReportWithValuesFailedWithError:error];
        return;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Request: %@",jsonString);
    
    [communicator makeAPICall:SendDonationListReportWithValues withContent:jsonString];
    
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
        
        //Handle invalid response
        if(d == nil)
        {
            d = [[NSDictionary alloc] initWithObjects:@[@"FAILURE",[NSNumber numberWithInt:12],@"Internal Server Error"] forKeys:@[@"status",@"errorCode",@"errorMessage"]];
        }
        
        NSLog(@"Result: %@",d);
        
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
            if([RegisterTrialUser isEqualToString:apiCall])
            {
                [delegate didRegisterTrialUser:currentUser];
            }
            else if([GetUserInfo isEqual:apiCall])
            {
                VPNUser* myUser = [VPNUser currentUser];
                [myUser populateWithDictionary:[d objectForKey:@"user"]];
                [VPNUser saveUserToDisc:myUser];
                
                [delegate didGetUser:myUser];
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
                if(nil != resultLists)
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
                if(nil != resultLists)
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
                if(nil != resultLists)
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
            else if([AddList isEqualToString:apiCall])
            {
                currentDonationList.ID = [[d objectForKey:@"id"] intValue];
                [delegate didAddList:currentDonationList];
            }
            else if([UpdateList isEqualToString:apiCall])
            {
                [delegate didUpdateList:currentDonationList];
            }
            else if([DeleteList isEqualToString:apiCall])
            {
                [delegate didDeleteList:currentDonationList];
            }
            else if([AddListItem isEqualToString:apiCall])
            {
                currentListItem.ID = [[d objectForKey:@"id"] intValue];
                [delegate didAddListItem:currentListItem];
            }
            else if([UpdateListItem isEqualToString:apiCall])
            {
                [delegate didUpdateListItem:currentListItem];
            }
            else if([DeleteListItem isEqualToString:apiCall])
            {
                [delegate didDeleteListItem:currentListItem];
            }
            else if([GetCategoryList isEqualToString:apiCall])
            {
                NSArray* resultLists = [d objectForKey:@"categories"];
                if(nil != resultLists && [resultLists count] > 0)
                {
                    [delegate didGetCategoryList:resultLists];
                }
                else
                {
                    [delegate didGetCategoryList:[NSDictionary dictionary]];
                }
            }
            else if([SendItemizedSummaryReport isEqualToString:apiCall])
            {
                [delegate didSendItemizedSummaryReport];
            }
            else if([SendTaxPrepSummaryReport isEqualToString:apiCall])
            {
                [delegate didSendTaxPrepSummaryReport];
            }
            else if([SendDonationListReportWithValues isEqualToString:apiCall])
            {
                [delegate didSendDonationListReportWithValues];
            }
        }
        else
        {
            NSLog(@"FAILURE");
            //create error and send to appropriate delegate method
            NSInteger apiErrorCode = [[d objectForKey:@"errorCode"] integerValue];
            NSDictionary* errorInfo = [NSDictionary dictionaryWithObject:[d objectForKey:@"errorMessage"] forKey:@"errorMessage"];
            
            NSError* apiError = [NSError errorWithDomain:APIErrorDomain code:apiErrorCode userInfo:errorInfo];
            
            if([LoginUser isEqual:apiCall])
                [delegate startingSessionFailedWithError:apiError];
            else if([RegisterTrialUser isEqual:apiCall])
                [delegate registerTrialUserFailedWithError:apiError];
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
            else if([AddList isEqualToString:apiCall])
                [delegate addListFailedWithError:apiError];
            else if([UpdateList isEqualToString:apiCall])
                [delegate updateListFailedWithError:apiError];
            else if([DeleteList isEqualToString:apiCall])
                [delegate deleteListFailedWithError:apiError];
            else if([AddListItem isEqualToString:apiCall])
                [delegate addListItemFailedWithError:apiError];
            else if([UpdateListItem isEqualToString:apiCall])
                [delegate updateListItemFailedWithError:apiError];
            else if([DeleteListItem isEqualToString:apiCall])
                [delegate deleteListItemFailedWithError:apiError];
            else if([GetCategoryList isEqualToString:apiCall])
                [delegate getCategoryListFailedWithError:apiError];
            else if([SendItemizedSummaryReport isEqualToString:apiCall])
                [delegate sendItemizedSummaryReportFailedWithError:apiError];
            else if([SendTaxPrepSummaryReport isEqualToString:apiCall])
                [delegate sendTaxPrepSummaryReportFailedWithError:apiError];
            else if([SendDonationListReportWithValues isEqualToString:apiCall])
                [delegate sendDonationListReportWithValuesFailedWithError:apiError];
            
        }
    }
    else
    {
        NSError* jsonError = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:nil];
        
        if([LoginUser isEqual:apiCall])
            [delegate startingSessionFailedWithError:jsonError];
        else if([RegisterTrialUser isEqual:apiCall])
            [delegate registerTrialUserFailedWithError:jsonError];
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
        else if([AddList isEqualToString:apiCall])
            [delegate addListFailedWithError:jsonError];
        else if([UpdateList isEqualToString:apiCall])
            [delegate updateListFailedWithError:jsonError];
        else if([DeleteList isEqualToString:apiCall])
            [delegate deleteListFailedWithError:jsonError];
        else if([AddListItem isEqualToString:apiCall])
            [delegate addListItemFailedWithError:jsonError];
        else if([UpdateListItem isEqualToString:apiCall])
            [delegate updateListItemFailedWithError:jsonError];
        else if([DeleteListItem isEqualToString:apiCall])
            [delegate deleteListItemFailedWithError:jsonError];
        else if([GetCategoryList isEqualToString:apiCall])
            [delegate getCategoryListFailedWithError:jsonError];
        else if([SendItemizedSummaryReport isEqualToString:apiCall])
            [delegate sendItemizedSummaryReportFailedWithError:jsonError];
        else if([SendTaxPrepSummaryReport isEqualToString:apiCall])
            [delegate sendTaxPrepSummaryReportFailedWithError:jsonError];
        else if([SendDonationListReportWithValues isEqualToString:apiCall])
            [delegate sendDonationListReportWithValuesFailedWithError:jsonError];
    }
}

-(void) receivedError:(NSError*)error forAPICall:(APICallType*)apiCall
{
    if([LoginUser isEqual:apiCall])
        [delegate startingSessionFailedWithError:error];
    else if([RegisterTrialUser isEqual:apiCall])
        [delegate registerTrialUserFailedWithError:error];
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
    else if([AddList isEqualToString:apiCall])
        [delegate addListFailedWithError:error];
    else if([UpdateList isEqualToString:apiCall])
        [delegate updateListFailedWithError:error];
    else if([DeleteList isEqualToString:apiCall])
        [delegate deleteListFailedWithError:error];
    else if([AddListItem isEqualToString:apiCall])
        [delegate addListItemFailedWithError:error];
    else if([UpdateListItem isEqualToString:apiCall])
        [delegate updateListItemFailedWithError:error];
    else if([DeleteListItem isEqualToString:apiCall])
        [delegate deleteListItemFailedWithError:error];
    else if([GetCategoryList isEqualToString:apiCall])
        [delegate getCategoryListFailedWithError:error];
    else if([SendItemizedSummaryReport isEqualToString:apiCall])
        [delegate sendItemizedSummaryReportFailedWithError:error];
    else if([SendTaxPrepSummaryReport isEqualToString:apiCall])
        [delegate sendTaxPrepSummaryReportFailedWithError:error];
    else if([SendDonationListReportWithValues isEqualToString:apiCall])
        [delegate sendDonationListReportWithValuesFailedWithError:error];
    
}


@end

NSString* VPNCDManagerError = @"VPNCDManagerError";
NSString* APIErrorDomain = @"APIErrorDomain";
