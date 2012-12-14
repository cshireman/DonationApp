//
//  VPNDonationList.m
//  DonationApp
//
//  Created by Chris Shireman on 12/6/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNDonationList.h"
#import "VPNItem.h"

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
    NSMutableDictionary* info = [[NSMutableDictionary alloc] initWithCapacity:11];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/y"];
    
    NSString* createDate = [formatter stringFromDate:self.creationDate];
    NSString* donateDate = [formatter stringFromDate:self.donationDate];
    
    [info setObject:[NSNumber numberWithInt:self.companyID] forKey:@"companyID"];
    [info setObject:createDate forKey:@"creationDate"];
    [info setObject:donateDate forKey:@"donationDate"];

    [info setObject:self.name forKey:@"name"];
    [info setObject:self.notes forKey:@"notes"];
    
    if(listType == 0)
    {
        [info setObject:self.dateAquired forKey:@"dateAquired"];
        [info setObject:self.howAquired forKey:@"howAquired"];
        
        [info setObject:costBasis forKey:@"costBasis"];
        [info setObject:@"" forKey:@"cashDonation"];
        [info setObject:@"" forKey:@"miles"];
    }
    else if(listType == 1)
    {
        [info setObject:@"" forKey:@"costBasis"];
        [info setObject:cashDonation forKey:@"cashDonation"];
        [info setObject:@"" forKey:@"miles"];
    }
    else if(listType == 2)
    {
        [info setObject:@"" forKey:@"costBasis"];
        [info setObject:@"" forKey:@"cashDonation"];
        [info setObject:mileage forKey:@"miles"];        
    }
    
    return info;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"ID:%d, CompanyID:%d",self.ID,self.companyID];
}

#pragma mark -
#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:ID forKey:@"ID"];
    [coder encodeInt:listType forKey:@"ListType"];
    [coder encodeInt:companyID forKey:@"CompanyID"];
    
    [coder encodeObject:creationDate forKey:@"CreationDate"];
    [coder encodeObject:donationDate forKey:@"DonationDate"];
    
    [coder encodeObject:name forKey:@"Name"];
    [coder encodeObject:dateAquired forKey:@"DateAquired"];
    [coder encodeObject:howAquired forKey:@"HowAquired"];
    
    [coder encodeObject:costBasis forKey:@"CostBasis"];
    [coder encodeObject:cashDonation forKey:@"CashDonation"];
    [coder encodeObject:mileage forKey:@"Mileage"];
    
    [coder encodeObject:notes forKey:@"Notes"];
    [coder encodeObject:items forKey:@"Items"];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        ID = [coder decodeIntForKey:@"ID"];
        listType = [coder decodeIntForKey:@"ListType"];
        companyID = [coder decodeIntForKey:@"CompanyID"];
        
        creationDate = [coder decodeObjectForKey:@"CreationDate"];
        donationDate = [coder decodeObjectForKey:@"DonationDate"];
        
        name = [coder decodeObjectForKey:@"Name"];
        dateAquired = [coder decodeObjectForKey:@"DateAquired"];
        howAquired = [coder decodeObjectForKey:@"HowAquired"];
        
        costBasis = [coder decodeObjectForKey:@"CostBasis"];
        cashDonation = [coder decodeObjectForKey:@"CashDonation"];
        mileage = [coder decodeObjectForKey:@"Mileage"];
        
        notes = [coder decodeObjectForKey:@"Notes"];
        items = [coder decodeObjectForKey:@"Items"];
    }
    
    return self;
}

#pragma mark -
#pragma mark NSCopying

-(id) copyWithZone:(NSZone *)zone
{
    VPNDonationList *copy = [[[self class] allocWithZone: zone] init];

    [copy setID:[self ID]];
    [copy setListType:[self listType]];
    [copy setCompanyID:[self companyID]];
    [copy setCreationDate:[self creationDate]];
    [copy setDonationDate:[self donationDate]];
    
    [copy setName:[self name]];
    [copy setDateAquired:[self dateAquired]];
    [copy setHowAquired:[self howAquired]];
    [copy setCostBasis:[self costBasis]];
    [copy setCashDonation:[self cashDonation]];
    
    [copy setMileage:[self mileage]];
    [copy setNotes:[self notes]];
    [copy setItems:[self items]];
    
    return copy;
}

-(double) totalForItems
{
    if(items == nil || [items count] == 0)
    {
        return 0.00;
    }
    
    double itemTotal = 0.00;
    for(VPNItem* item in items)
    {
        itemTotal += (item.quantity * [item.fairMarketValue doubleValue]);
    }
    
    return itemTotal;
}



@end
