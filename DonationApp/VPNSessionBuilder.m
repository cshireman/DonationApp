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
    }
    
    VPNSession* session = [[VPNSession alloc] init];
    
    return nil;
    
}

@end

NSString* VPNSessionBuilderError = @"SessionBuilderError";
