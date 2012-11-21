//
//  VPNCDManager.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNCDManager.h"

NSString* const APIKey = @"12C7DCE347154B5A8FD49B72F169A975";

@implementation VPNCDManager
@synthesize delegate;
@synthesize communicator;
@synthesize userBuilder;
@synthesize sessionBuilder;

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
            else if([ChangePassword isEqualToString:apiCall])
                [delegate changePasswordFailedWithError:apiError];
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
        else if([ChangePassword isEqualToString:apiCall])
            [delegate changePasswordFailedWithError:jsonError];
    }
}

-(void) receivedError:(NSError*)error forAPICall:(APICallType*)apiCall
{
    if([LoginUser isEqual:apiCall])
    {
        [delegate startingSessionFailedWithError:error];
    }
    else if([GetUserInfo isEqual:apiCall])
    {
        [delegate getUserInfoFailedWithError:error];
    }
    else if([GetOrganizations isEqual:apiCall])
    {
        [delegate getOrganizationsFailedWithError:error];
    }
    else if([GetYears isEqual:apiCall])
    {
        [delegate getTaxYearsFailedWithError:error];
    }
    else if([ChangePassword isEqual:apiCall])
    {
        [delegate changePasswordFailedWithError:error];
    }
}


@end

NSString* VPNCDManagerError = @"VPNCDManagerError";
NSString* APIErrorDomain = @"APIErrorDomain";
