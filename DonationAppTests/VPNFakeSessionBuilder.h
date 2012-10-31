//
//  VPNFakeSessionBuilder.h
//  DonationApp
//
//  Created by Chris Shireman on 10/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNSession.h"
#import "VPNSessionBuilder.h"

@interface VPNFakeSessionBuilder : VPNSessionBuilder

@property (copy) NSString* JSON;
@property (copy) NSError* errorToSet;

@property (strong) VPNSession* sessionToReturn;

@end
