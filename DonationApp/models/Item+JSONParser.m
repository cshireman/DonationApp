//
//  Item+JSONParser.m
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "Item+JSONParser.h"
#import "ItemValue+JSONParser.h"
#import "VPNAppDelegate.h"

@implementation Item (JSONParser)

+(Item*) getByItemID:(int)itemID
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"(itemID = %d)",itemID];
    [fetchRequest setPredicate:pred];
    
    NSError* error;
    NSArray* objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if(objects == nil)
    {
        NSLog(@"There was an error");
        return nil;
    }
    
    //If there is something existing, return it
    if([objects count] > 0)
        return [objects objectAtIndex:0];
    
    //Otherwise insert a new record
    Item* newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
    
    newItem.itemID = [NSNumber numberWithInt:itemID];
    
    return newItem;
}

-(void) populateWithDictionary:(NSDictionary*)info
{
    self.itemID = (NSNumber*)[info objectForKey:@"ID"];
    self.name = (NSString*)[info objectForKey:@"Name"];
    
    NSArray* values = (NSArray*)[info objectForKey:@"Values"];
    if(values != nil && [values count] > 0)
    {
        [self removeValues:self.values];
        for(NSDictionary* value in values)
        {
            ItemValue* newValue = [ItemValue itemValueWithDictionary:value];
            [self addValuesObject:newValue];
        }
    }
}

@end
