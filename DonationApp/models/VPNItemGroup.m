//
//  VPNItemGroup.m
//  DonationApp
//
//  Created by Chris Shireman on 12/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNItemGroup.h"
#import "Category.h"

@implementation VPNItemGroup

@synthesize donationList;
@synthesize items;
@synthesize summary;
@synthesize itemID;
@synthesize isCustom;
@synthesize conditions;

@synthesize categoryName;
@synthesize itemName;
@synthesize image;

+(NSArray*) groupsFromItemsInDonationList:(VPNDonationList*)donationList
{
    NSMutableDictionary* groups = [[NSMutableDictionary alloc] init];
    NSArray* items = donationList.items;
    
    for(VPNItem* item in items)
    {
        NSString* key = [[NSNumber numberWithInt:item.itemID] stringValue];
        VPNItemGroup* itemGroup = [groups objectForKey:key];
        
        if(itemGroup == nil)
        {
            itemGroup = [[VPNItemGroup alloc] init];
            itemGroup.items = [[NSMutableArray alloc] init];
            itemGroup.donationList = donationList;
            
            itemGroup.itemName = item.name;
            itemGroup.itemID = item.itemID;
            itemGroup.isCustom = item.isCustomItem;
            
            Category* category = [Category loadCategoryForID:item.categoryID];
            
            if(category != nil)
                itemGroup.categoryName = category.name;
            else
                itemGroup.categoryName = @"Unknown";
            
            //TODO: Add code to get category info from core data
        }
        
        [itemGroup.items addObject:item];
        [groups setObject:itemGroup forKey:key];
    }

    NSArray* groupKeys = [groups allKeys];
    
    for(NSString* key in groupKeys)
    {
        VPNItemGroup* itemGroup = [groups objectForKey:key];
        [itemGroup buildItemSummary];
        [groups setObject:itemGroup forKey:key];
    }
    
    NSMutableArray* groupValues = [NSMutableArray arrayWithArray:[groups allValues]];
    [groupValues sortUsingComparator:^NSComparisonResult(VPNItemGroup* obj1, VPNItemGroup* obj2) {
        return [obj1.itemName compare:obj2.itemName];
    }];
    
    return groupValues;
}

-(int) quantityForCondition:(ItemCondition)condition
{
    int quantity = 0;
    for(VPNItem* item in items)
    {
        if(item.condition == condition)
            quantity += item.quantity;
    }
    
    return quantity;
}

-(double) valueForCondition:(ItemCondition)condition
{
    double value = 0.00;
    for(VPNItem* item in items)
    {
        if(item.condition == condition)
            value += [item.fairMarketValue doubleValue];
    }
    
    return value;
}

-(void) setQuantity:(int)quantity forCondition:(ItemCondition)condition
{
    for(VPNItem* item in items)
    {
        if(item.condition == condition)
        {
            item.quantity = quantity;
            break;
        }
    }
}

-(void) setValue:(double)value forCondition:(ItemCondition)condition
{
    for(VPNItem* item in items)
    {
        if(item.condition == condition)
        {
            item.fairMarketValue = [NSNumber numberWithDouble:value];
            break;
        }
    }
}


-(BOOL) addValue:(NSNumber*)value toObjectWithKey:(NSString*)key inDictionary:(NSMutableDictionary*)info
{
    NSNumber* quantity = [info objectForKey:key];
    BOOL existed = NO;
    
    if(quantity == nil)
    {
        quantity = value;
    }
    else
    {
        existed = YES;
        double newQuantity = [value doubleValue] + [quantity doubleValue];
        quantity = [NSNumber numberWithDouble:newQuantity];
    }
    
    [info setObject:quantity forKey:key];
    return existed;
}

-(NSDictionary*) buildItemSummary
{
    conditions = [[NSMutableArray alloc] init];;
    summary = [NSMutableDictionary dictionaryWithCapacity:16];
    
    double total = 0.00;
    
    for(VPNItem* item in items)
    {
        NSString* quantityKey = [NSString stringWithFormat:@"quantity_%d",item.condition];
        NSString* fmvKey = [NSString stringWithFormat:@"fmv_%d",item.condition];
        NSString* subtotalKey = [NSString stringWithFormat:@"subtotal_%d",item.condition];
        
        double subtotal = item.quantity * [item.fairMarketValue doubleValue];
        total += subtotal;

        BOOL existed = [self addValue:[NSNumber numberWithInt:item.quantity] toObjectWithKey:quantityKey inDictionary:summary];
        [self addValue:item.fairMarketValue toObjectWithKey:fmvKey inDictionary:summary];
        [self addValue:[NSNumber numberWithDouble:subtotal] toObjectWithKey:subtotalKey inDictionary:summary];
        
        if(!existed)
        {
            [conditions addObject:[NSNumber numberWithInt:item.condition]];
        }
    }
    
    [summary setObject:[NSNumber numberWithDouble:total] forKey:@"total"];
    
    return summary;
}

-(void) saveImageToDisc:(UIImage*)image
{
    NSData* imageData = UIImagePNGRepresentation(image);
    NSString* filePath = [self imageFilename];
    
    [imageData writeToFile:filePath atomically:YES];
}

-(UIImage*) loadImageFromDisc
{
    NSString* filePath = [self imageFilename];
    image = [UIImage imageWithContentsOfFile:filePath];
    
    return image;
}

-(NSString*) imageFilename
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%d_%d",donationList.ID,itemID];
    
    return [documentsDirectory stringByAppendingPathComponent:filePath];
}

@end
