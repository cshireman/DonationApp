//
//  VPNDonationList.m
//  DonationApp
//
//  Created by Chris Shireman on 12/6/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNDonationList.h"

@implementation VPNDonationList

@synthesize ID;
@synthesize listType;
@synthesize companyID;
@synthesize creationDate;
@synthesize donationDate;
@synthesize name;
@synthesize dateAquired;
@synthesize howAquired;
@synthesize costBasis;
@synthesize cashDonation;
@synthesize mileage;
@synthesize notes;
@synthesize items;

-(NSMutableDictionary*)toDictionary
{
    return [NSMutableDictionary dictionary];
}

@end
