//
//  VPNItem.m
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNItem.h"

@implementation VPNItem

@synthesize ID;
@synthesize creationDate;
@synthesize condition;
@synthesize valuation;
@synthesize categoryID;
@synthesize itemID;
@synthesize name;
@synthesize quantity;
@synthesize fairMarketValue;
@synthesize isCustomItem;
@synthesize isCustomValue;
@synthesize notes;

#pragma mark -
#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:ID forKey:kVPNItemIDKey];
    
    [coder encodeObject:creationDate forKey:kVPNItemCreationDateKey];
    
    [coder encodeInt:condition forKey:kVPNItemConditionKey];
    [coder encodeInt:valuation forKey:kVPNItemValuationKey];
    [coder encodeInt:categoryID forKey:kVPNItemCategoryIDKey];
    [coder encodeInt:itemID forKey:kVPNItemItemIDKey];
    
    [coder encodeObject:name forKey:kVPNItemNameKey];
    
    [coder encodeInt:quantity forKey:kVPNItemQuantityKey];

    [coder encodeObject:fairMarketValue forKey:kVPNItemFairMarketValueKey];

    [coder encodeBool:isCustomItem forKey:kVPNItemIsCustomItemKey];
    [coder encodeBool:isCustomValue forKey:kVPNItemIsCustomValueKey];
    
    [coder encodeObject:notes forKey:kVPNItemNotesKey];
    
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        self.ID = [coder decodeIntForKey:kVPNItemIDKey];
        
        self.creationDate = [coder decodeObjectForKey:kVPNItemCreationDateKey];
        
        self.condition = [coder decodeIntForKey:kVPNItemConditionKey];
        self.valuation = [coder decodeIntForKey:kVPNItemValuationKey];
        self.categoryID = [coder decodeIntForKey:kVPNItemCategoryIDKey];
        self.itemID = [coder decodeIntForKey:kVPNItemItemIDKey];
        
        self.name = [coder decodeObjectForKey:kVPNItemNameKey];
        
        self.quantity = [coder decodeIntForKey:kVPNItemQuantityKey];
        
        self.fairMarketValue = [coder decodeObjectForKey:kVPNItemFairMarketValueKey];
        
        self.isCustomItem = [coder decodeBoolForKey:kVPNItemIsCustomItemKey];
        self.isCustomValue = [coder decodeBoolForKey:kVPNItemIsCustomValueKey];
        
        self.notes = [coder decodeObjectForKey:kVPNItemNotesKey];
    }
    
    return self;
}

-(id) copyWithZone:(NSZone *)zone
{
    VPNItem* copy = [[[self class] allocWithZone:zone] init];
    
    [copy setID:[self ID]];
    [copy setCreationDate:[self creationDate]];
    [copy setCondition:[self condition]];
    [copy setValuation:[self valuation]];
    [copy setCategoryID:[self categoryID]];
    
    [copy setItemID:[self itemID]];
    [copy setName:[self name]];
    [copy setQuantity:[self quantity]];
    [copy setFairMarketValue:[self fairMarketValue]];
    [copy setIsCustomItem:[self isCustomItem]];
    
    [copy setIsCustomValue:[self isCustomValue]];
    [copy setNotes:[self notes]];
    
    return copy;
}

-(id) initWithDictionary:(NSDictionary*)info
{
    self = [super init];
    
    if(self)
    {
        NSLog(@"%@",info);
        self.ID = [[info objectForKey:@"ID"] intValue];
        
        self.creationDate = [NSDate dateWithTimeIntervalSince1970:[[info objectForKey:@"CreationDate"] doubleValue]];

        self.condition = [[info objectForKey:@"Condition"] intValue];
        self.valuation = [[info objectForKey:@"Valuation"] intValue];
        self.categoryID = [[info objectForKey:@"Category"] intValue];
        self.itemID = [[info objectForKey:@"ItemID"] intValue];
        
        self.name = [info objectForKey:@"Name"];
        
        self.quantity = [[info objectForKey:@"Quantity"] intValue];

        self.fairMarketValue = [info objectForKey:@"FairMarketValue"];
        
        self.isCustomItem = [[info objectForKey:@"IsCustomItem"] boolValue];
        self.isCustomValue = [[info objectForKey:@"IsCustomValue"] boolValue];
        
        self.notes = [info objectForKey:@"Notes"];
    }
    
    return self;
}

-(NSDictionary*) toDictionary
{
    NSMutableDictionary* info = [NSMutableDictionary dictionary];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/y"];
    
    NSString* createDate = [formatter stringFromDate:self.creationDate];
    
    [info setObject:createDate forKey:@"creationDate"];
    
    [info setObject:[NSNumber numberWithInt:self.condition] forKey:@"condition"];
    [info setObject:[NSNumber numberWithInt:self.valuation] forKey:@"valuation"];
    [info setObject:[NSNumber numberWithInt:self.categoryID] forKey:@"category"];
    
    if(self.isCustomItem)
        [info setObject:@"" forKey:@"itemID"];
    else
        [info setObject:[NSNumber numberWithInt:self.itemID] forKey:@"itemID"];
    
    [info setObject:self.name forKey:@"name"];
    [info setObject:[NSNumber numberWithInt:self.quantity] forKey:@"quantity"];
    
    if(self.fairMarketValue == nil)
        [info setObject:@"" forKey:@"fairMarketValue"];
    else
        [info setObject:self.fairMarketValue forKey:@"fairMarketValue"];
    
    if(self.isCustomItem)
    {
        [info setObject:@"1" forKey:@"isCustomItem"];
        [info setObject:@"1" forKey:@"isCustomValue"];
    }
    else
    {
        [info setObject:@"0" forKey:@"isCustomItem"];
        [info setObject:@"0" forKey:@"isCustomValue"];
    }
    
    [info setObject:self.notes forKey:@"notes"];
    
    return info;
    
}

@end
