//
//  Item.m
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "Item.h"
#import "Category.h"
#import "ItemValue.h"
#import "VPNUser.h"
#import "VPNAppDelegate.h"


@implementation Item

@dynamic itemID;
@dynamic name;
@dynamic taxYear;
@dynamic values;
@dynamic category;

+(Item*) loadItemForID:(int)itemID
{
    VPNUser* user = [VPNUser currentUser];
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:context];
        
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"(itemID = %d AND taxYear = %d)",itemID,user.selected_tax_year];
    [fetchRequest setPredicate:pred];
    [fetchRequest setEntity:entity];
    
    Item* item = nil;
    NSError* error;
    
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    if(results == nil)
        return nil;
    
    if([results count] > 0)
        item = (Item*)[results objectAtIndex:0];
    
    return item;
}

+(NSArray*) loadItemsForCategoryID:(int)categoryID
{
    VPNUser* user = [VPNUser currentUser];
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:context];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"(categoryID = %d AND taxYear = %d)",categoryID,user.selected_tax_year];
    [fetchRequest setPredicate:pred];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    
    return [context executeFetchRequest:fetchRequest error:&error];
}

+(NSArray*) keywordSearch:(NSString*)keyword
{
    VPNUser* user = [VPNUser currentUser];
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:context];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"(name contains[cd] %@ AND taxYear = %d)",keyword,user.selected_tax_year];
    [fetchRequest setPredicate:pred];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    
    return [context executeFetchRequest:fetchRequest error:&error];
    
}


@end
