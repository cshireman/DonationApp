//
//  VPNCDManager.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNCDManager.h"


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
    [request setObject:@"12C7DCE347154B5A8FD49B72F169A975" forKey:@"apiKey"];
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
    
}

-(void) getOrganizations:(BOOL)forceDownload
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
                [[VPNSession currentSession] populateWithDictionary:d];
                [delegate didStartSession];
            }
        }
        else
        {
            //create error and send to appropriate delegate method
            NSInteger apiErrorCode = [[d objectForKey:@"errorCode"] integerValue];
            NSDictionary* errorInfo = [NSDictionary dictionaryWithObject:[d objectForKey:@"errorMessage"] forKey:@"errorMessage"];
            
            NSError* apiError = [NSError errorWithDomain:APIErrorDomain code:apiErrorCode userInfo:errorInfo];
            
            [delegate startingSessionFailedWithError:apiError];
        }
    }
    else
    {
        NSError* jsonError = [NSError errorWithDomain:VPNCDManagerError code:VPNCDManagerInvalidJSONError userInfo:nil];
        
        [delegate startingSessionFailedWithError:jsonError];
    }
}

-(void) receivedError:(NSError*)error forAPICall:(APICallType*)apiCall
{
    if([LoginUser isEqual:apiCall])
    {
        [delegate startingSessionFailedWithError:error];
    }
}


@end

NSString* VPNCDManagerError = @"VPNCDManagerError";
NSString* APIErrorDomain = @"APIErrorDomain";
