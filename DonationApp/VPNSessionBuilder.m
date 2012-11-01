//
//  VPNSessionBuilder.m
//  DonationApp
//
//  Created by Chris Shireman on 10/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSessionBuilder.h"

@implementation VPNSessionBuilder

-(VPNSession*)sessionFromJSON:(NSString*)objectNotation error:(NSError**)error
{
    NSParameterAssert(objectNotation != nil);
    NSData* unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError* localError = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation options:0 error:&localError];
    NSDictionary* parsedObject = (id)jsonObject;
    if(parsedObject == nil)
    {
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:VPNSessionBuilderError code:VPNSessionBuilderInvalidJSONError userInfo:nil];
        }
        
        return nil;
    }
    
    NSDictionary* sessionInfo = [parsedObject objectForKey:@"d"];
    
    //Make sure there is a session attribute in the JSON
    NSArray* keys = [sessionInfo allKeys];
    BOOL sessionKeyFound = NO;
    for(NSString* key in keys)
    {
        if([key isEqualToString:@"session"])
        {
            sessionKeyFound = YES;
            break;
        }
    }
    
    //If there was no session found, return with error
    if(!sessionKeyFound)
    {
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:VPNSessionBuilderError code:VPNSessionBuilderMissingDataError userInfo:nil];
        }
        
        return nil;
    }
    
    VPNSession* session = [[VPNSession alloc] initWithDictionary:sessionInfo];
    
    return session;
    
}

@end

NSString* VPNSessionBuilderError = @"SessionBuilderError";
