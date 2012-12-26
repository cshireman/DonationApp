//
//  VPNUserBuilder.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNUserBuilder.h"

@implementation VPNUserBuilder

-(VPNUser*)userFromJSON:(NSString*)objectNotation error:(NSError**)error
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
            *error = [NSError errorWithDomain:VPNUserBuilderError code:VPNUserBuilderInvalidJSONError userInfo:nil];
        }
    }
        
    return nil;
}

@end

NSString* VPNUserBuilderError = @"UserBuilderError";
