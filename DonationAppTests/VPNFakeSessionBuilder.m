//
//  VPNFakeSessionBuilder.m
//  DonationApp
//
//  Created by Chris Shireman on 10/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNFakeSessionBuilder.h"

@implementation VPNFakeSessionBuilder
@synthesize JSON;
@synthesize sessionToReturn;
@synthesize errorToSet;

-(VPNSession*) sessionFromJSON:(NSString *)objectNotation error:(NSError **)error
{
    self.JSON = objectNotation;
    *error = errorToSet;
    
    return sessionToReturn;
}

@end
