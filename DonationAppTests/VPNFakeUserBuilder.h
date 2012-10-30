//
//  VPNFakeUserBuilder.h
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNUserBuilder.h"

@interface VPNFakeUserBuilder : VPNUserBuilder

@property (copy) NSString* JSON;
@property (copy) NSError* errorToSet;

@property (strong) VPNUser* userToReturn;

@end
