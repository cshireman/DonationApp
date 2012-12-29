//
//  VPNItemGroup.m
//  DonationApp
//
//  Created by Chris Shireman on 12/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNItemGroup.h"
#import "Category.h"
#import "Item.h"
#import "ItemValue.h"

@implementation VPNItemGroup

@synthesize delegate;

@synthesize donationList;
@synthesize items;
@synthesize summary;
@synthesize itemID;
@synthesize categoryID;
@synthesize isCustom;
@synthesize isNew;
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
        if(item.isCustomItem)
            key = item.name;
        
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
            {
                itemGroup.categoryName = category.name;
                itemGroup.categoryID = [category.categoryID intValue];
            }
            else
            {
                itemGroup.categoryName = @"Unknown";
                itemGroup.categoryID = 0;
            }
            
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
    if(isCustom)
    {
        double value = 0.00;
        for(VPNItem* item in items)
        {
            if(item.condition == condition)
                value += [item.fairMarketValue doubleValue];
        }
        
        return value;
    }
    else
    {
        if(dbItem == nil)
        {
            dbItem = [Item loadItemForID:itemID];
        }
        
        NSSet* values = dbItem.values;
        for(ItemValue* itemValue in values)
        {
            if([itemValue.condition intValue] == condition)
            {
                return [itemValue.value doubleValue];
            }
        }
    }
    
    return 0.00;
}

-(void) setQuantity:(int)quantity forCondition:(ItemCondition)condition
{
    BOOL itemFound = NO;
    for(VPNItem* item in items)
    {
        if(item.condition == condition)
        {
            itemFound = YES;
            item.quantity = quantity;
            break;
        }
    }
    
    if(!itemFound)
    {
        VPNItem* newItem = [[VPNItem alloc] init];
        newItem.quantity = quantity;
        newItem.condition = condition;
        
        if(items == nil)
            items = [NSMutableArray array];        
        
        [items addObject:newItem];
    }
}

-(void) setValue:(double)value forCondition:(ItemCondition)condition
{
    BOOL itemFound = NO;
    for(VPNItem* item in items)
    {
        if(item.condition == condition)
        {
            itemFound = YES;
            item.fairMarketValue = [NSNumber numberWithDouble:value];
            break;
        }
    }
    
    if(!itemFound)
    {
        VPNItem* newItem = [[VPNItem alloc] init];
        newItem.fairMarketValue = [NSNumber numberWithDouble:value];
        newItem.condition = condition;
        
        if(items == nil)
            items = [NSMutableArray array];
        
        [items addObject:newItem];
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

-(int) totalQuantityForAllConditons
{
    int total = 0;
    
    total += [self quantityForCondition:Mint];
    total += [self quantityForCondition:Excellent];
    total += [self quantityForCondition:VeryGood];
    total += [self quantityForCondition:Good];
    total += [self quantityForCondition:Fair];
    
    return total;
}

-(double) totalValueForAllConditions
{
    double total = 0.00;
    
    total += [self valueForCondition:Mint];
    total += [self valueForCondition:Excellent];
    total += [self valueForCondition:VeryGood];
    total += [self valueForCondition:Good];
    total += [self valueForCondition:Fair];
    
    return total;    
}


-(NSDictionary*) buildItemSummary
{
    conditions = [[NSMutableArray alloc] init];;
    summary = [NSMutableDictionary dictionaryWithCapacity:16];
    
    double total = 0.00;
    
    if(self.isCustom)
        NSLog(@"Custom Item Found");
    
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

-(void) saveImageToDisc:(UIImage*)localImage
{
    NSData* imageData = UIImagePNGRepresentation(localImage);
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

-(void) save
{
    if(manager == nil)
    {
        manager = [[VPNCDManager alloc] init];
        manager.delegate = self;
    }
    
    //Build list of items to add, update, and delete
    itemsToAdd = [NSMutableArray array];
    itemsToUpdate = [NSMutableArray array];
    itemsToDelete = [NSMutableArray array];
    
    for(VPNItem* currentItem in items)
    {
        currentItem.itemID = itemID;
        currentItem.categoryID = categoryID;
        currentItem.name = itemName;
        currentItem.valuation = Other;
        
        currentItem.isCustomItem = isCustom;
        currentItem.isCustomValue = isCustom;
        currentItem.notes = @"";
        
        if(currentItem.ID == 0 && currentItem.quantity != 0)
        {
            currentItem.creationDate = [NSDate date];
            [itemsToAdd addObject:currentItem];
        }
        else if(currentItem.ID != 0 && currentItem.quantity != 0)
        {
            [itemsToUpdate addObject:currentItem];
        }
        else if(currentItem.ID != 0 && currentItem.quantity == 0)
        {
            [itemsToDelete addObject:currentItem];
        }
    }
    
    [self saveNextItem];
}

-(void) saveNextItem
{
    if([itemsToAdd count] > 0)
    {
        [manager addDonationListItem:[itemsToAdd objectAtIndex:0] toDonationList:donationList];
    }
    else if([itemsToUpdate count] > 0)
    {
        [manager updateDonationListItem:[itemsToUpdate objectAtIndex:0] onDonationList:donationList];
    }
    else if([itemsToDelete count] > 0)
    {
        [manager deleteDonationListItem:[itemsToDelete objectAtIndex:0] fromDonationList:donationList];
    }
    else
    {
        //All lists are empty, finished processing so inform delegate
        [delegate didFinishSavingItemGroup];
    }
}

-(void) deleteAllItems
{
    if(manager == nil)
    {
        manager = [[VPNCDManager alloc] init];
        manager.delegate = self;
    }

    
    itemsToAdd = [NSMutableArray array];
    itemsToUpdate = [NSMutableArray array];
    itemsToDelete = [NSMutableArray arrayWithArray:items];
    
    [self saveNextItem];
}

#pragma mark -
#pragma mark VPNCDManagerDelegate Methods

-(void) didAddListItem:(id)item
{
    if([itemsToAdd count] > 0)
        [itemsToAdd removeObjectAtIndex:0];
    
    [self saveNextItem];
}
-(void) addListItemFailedWithError:(NSError*)error
{
    [delegate saveFailedWithError:error];
}

-(void) didUpdateListItem:(id)item
{
    if([itemsToUpdate count] > 0)
        [itemsToUpdate removeObjectAtIndex:0];
    
    [self saveNextItem];
}

-(void) updateListItemFailedWithError:(NSError*)error
{
    [delegate saveFailedWithError:error];
}

-(void) didDeleteListItem:(id)item
{
    if([itemsToDelete count] > 0)
        [itemsToDelete removeObjectAtIndex:0];
    
    [self saveNextItem];    
}

-(void) deleteListItemFailedWithError:(NSError*)error
{
    [delegate saveFailedWithError:error];    
}


@end
