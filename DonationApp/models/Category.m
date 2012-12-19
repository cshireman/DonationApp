//
//  Category.m
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNAppDelegate.h"
#import "VPNUser.h"
#import "Category.h"
#import "Item.h"


@implementation Category

@dynamic categoryID;
@dynamic name;
@dynamic taxYear;
@dynamic parentCategoryID;
@dynamic categories;
@dynamic items;

+(Category*) loadCategoryForID:(int)categoryID
{
    VPNUser* user = [VPNUser currentUser];
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:context];
    
    NSLog(@"CategoryID: %d, TaxYear:%d",categoryID,user.selected_tax_year);
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"(categoryID = %d AND taxYear = %d)",categoryID,user.selected_tax_year];
    [fetchRequest setPredicate:pred];
    [fetchRequest setEntity:entity];
    
    Category* category = nil;
    NSError* error;
    
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    if(results == nil)
        return nil;
    
    if([results count] > 0)
        category = (Category*)[results objectAtIndex:0];
    
    return category;
}

@end
