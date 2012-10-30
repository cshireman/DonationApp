//
//  VPNFakeUserBuilder.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNFakeUserBuilder.h"

@implementation VPNFakeUserBuilder
@synthesize JSON;
@synthesize userToReturn;
@synthesize errorToSet;

-(VPNUser*) userFromJSON:(NSString *)objectNotation error:(NSError **)error
{
    self.JSON = objectNotation;
    *error = errorToSet;
    
    return userToReturn;
}

@end
