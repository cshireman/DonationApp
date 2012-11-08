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

-(void)startSessionForUserFailedWithError:(NSError*)error
{
    [self tellDelegateAboutError:error];
}

-(void)receivedUserJSON:(NSString*)objectNotation
{
    NSError* error = nil;
    VPNUser* user = [userBuilder userFromJSON:objectNotation error:&error];
    
    if(!user)
    {
        [self tellDelegateAboutError:error];
    }
    else
    {
        [delegate didGetUser:user];
    }
}

-(void)receivedSessionJSON:(NSString*)objectNotation
{
    NSError* error = nil;
    VPNSession* session = [sessionBuilder sessionFromJSON:objectNotation error:&error];
    
    if(session == nil)
    {
        [self tellDelegateAboutError:error];
    }
    else
    {
        [delegate didStartSession:session];
    }
}


-(void) tellDelegateAboutError:(NSError*) error
{
    NSDictionary* errorInfo = nil;
    if(error)
    {
        errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    }
    
    NSError* reportableError = [NSError errorWithDomain:VPNCDManagerError
                                                   code:VPNCDManagerErrorStartSessionCode
                                               userInfo:errorInfo];
    
    [delegate startingSessionFailedWithError:reportableError];    
}

-(NSArray*) getOrganizations
{
    return nil;
}

#pragma mark -
#pragma mark Communicator Delegate Methods

-(void) receivedResponse:(NSString*)response forAPICall:(APICallType*)apiCall
{
    
}

-(void) receivedError:(NSError*)error forAPICall:(APICallType*)apiCall
{
    
}


@end

NSString* VPNCDManagerError = @"VPNCDManagerError";
