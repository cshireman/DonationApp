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
    [communicator startSessionForUser:user];
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
        [delegate didStartSessionWithUser:user];
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

@end

NSString* VPNCDManagerError = @"VPNCDManagerError";
