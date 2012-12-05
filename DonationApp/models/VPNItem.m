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

-(id) initWithDictionary:(NSDictionary*)info
{
    self = [super init];
    
    if(self)
    {
        self.ID = [[info objectForKey:@"ID"] intValue];
        
        self.creationDate = [NSDate dateWithTimeIntervalSince1970:[[info objectForKey:@"CreationDate"] doubleValue]];

        self.condition = [[info objectForKey:@"Condition"] intValue];
        self.valuation = [[info objectForKey:@"Valuation"] intValue];
        self.categoryID = [[info objectForKey:@"CategoryID"] intValue];
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

@end
