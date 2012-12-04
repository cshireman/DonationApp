//
//  ItemValue+JSONParser.m
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "ItemValue+JSONParser.h"
#import "VPNAppDelegate.h"

@implementation ItemValue (JSONParser)

+(ItemValue*) itemValueWithDictionary:(NSDictionary*) info
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    
    //Otherwise insert a new record
    ItemValue* newItemValue = [NSEntityDescription insertNewObjectForEntityForName:@"ItemValue" inManagedObjectContext:context];
    
    newItemValue.condition = (NSNumber*)[info objectForKey:@"Condition"];
    newItemValue.valuation = (NSNumber*)[info objectForKey:@"Valuation"];
    newItemValue.value = (NSNumber*)[info objectForKey:@"Value"];
    
    return newItemValue;
}

@end
