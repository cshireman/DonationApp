//
//  VPNDonationListGroup.m
//  DonationApp
//
//  Created by Chris Shireman on 12/13/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNDonationListGroup.h"

@implementation VPNDonationListGroup

@synthesize listType;
@synthesize donationLists;
@synthesize organization;
@synthesize lastDonationDate;

-(double) totalForAllLists
{
    double total = 0.00;

    if(donationLists == nil || [donationLists count] == 0)
        return total;
    
    for(VPNDonationList* donationList in donationLists)
    {
        if(listType == 0)
            total += [donationList totalForItems];
        else if(listType == 1)
            total += [donationList.cashDonation doubleValue];
        else if(listType == 2)
            total += [donationList.mileage doubleValue];
    }
    
    return total;
}

-(void) addDonationList:(VPNDonationList*)listToAdd
{
    if(donationLists == nil)
        donationLists = [[NSMutableArray alloc] initWithCapacity:1];
    
    [donationLists addObject:listToAdd];
    [self updateLastDonationDate];
}

-(void) removeDonationList:(VPNDonationList*)listToRemove
{
    if(donationLists == nil)
    {
        return;
    }
    
    VPNDonationList* listToDelete = nil;
    for(VPNDonationList* donationList in donationLists)
    {
        if(donationList.ID == listToRemove.ID)
            listToDelete = donationList;
    }
    
    if(listToDelete != nil)
    {
        NSLog(@"Removing list: %@",listToDelete);
        [donationLists removeObject:listToDelete];
    }
    else
    {
        NSLog(@"Not removing list:%@",listToRemove);
    }
    
    [self updateLastDonationDate];
}

-(void) updateLastDonationDate
{
    if(donationLists == nil || [donationLists count] == 0)
    {
        return;
    }
    
    for(VPNDonationList* donationList in donationLists)
    {
        if(lastDonationDate == nil)
            lastDonationDate = donationList.donationDate;
        else
            lastDonationDate = [donationList.donationDate laterDate:lastDonationDate];
    }
}

@end
