//
//  Category+JSONParser.m
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "Category+JSONParser.h"
#import "Item+JSONParser.h"
#import "VPNAppDelegate.h"

@implementation Category (JSONParser)

+(Category*) getByCategoryID:(int)categoryID
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"(categoryID = %d)",categoryID];
    [fetchRequest setPredicate:pred];
    
    NSError* error;
    NSArray* objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if(objects == nil)
    {
        NSLog(@"There was an error");
        return nil;
    }
    
    if([objects count] > 0)
    {
        NSLog(@"Loading category: %d",categoryID);        
        return [objects objectAtIndex:0];
    }

    Category* newCat = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:context];
    
    newCat.categoryID = [NSNumber numberWithInt:categoryID];
    NSLog(@"Loading category: %d",categoryID);
    
    return newCat;
}

+(Category*) newCategoryForCategoryID:(int)categoryID
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];
    Category* newCat = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:context];
    
    newCat.categoryID = [NSNumber numberWithInt:categoryID];
    NSLog(@"New Category for %d",categoryID);
    
    return newCat;
}

+(NSArray*) getByTaxYear:(int)taxYear
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [appDelegate managedObjectContext];

    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:context];

    [fetchRequest setEntity:entity];

    NSPredicate* pred = [NSPredicate predicateWithFormat:@"(taxYear = %d AND parentCategoryID = 0)",taxYear];
    [fetchRequest setPredicate:pred];

    NSError* error;
    NSArray* objects = [context executeFetchRequest:fetchRequest error:&error];
    
    return objects;
}

-(void) populateWithDictionary:(NSDictionary*)info
{
    self.categoryID = (NSNumber*)[info objectForKey:@"ID"];
    self.name = (NSString*)[info objectForKey:@"Name"];
    self.taxYear = (NSNumber*)[info objectForKey:@"TaxYear"];
    
    NSString* catPath = (NSString*)[info objectForKey:@"Path"];
    
    if(catPath == nil)
    {
        self.path = @"";
        catPath = self.name;
    }
    else
    {
        self.path = catPath;
        catPath = [catPath stringByAppendingFormat:@": %@",self.name];
    }
    
    NSNumber* parentCatID = (NSNumber*)[info objectForKey:@"ParentCategoryID"];
    if(parentCatID != nil)
        self.parentCategoryID = parentCatID;
    else
        self.parentCategoryID = [NSNumber numberWithInt:0];
    
    NSArray* subCats = (NSArray*)[info objectForKey:@"Categories"];
    if(subCats != nil && [subCats count] > 0)
    {
        NSMutableSet* subcatSet = [[NSMutableSet alloc] initWithCapacity:[subCats count]];
        for(NSDictionary* subCat in subCats)
        {
            NSMutableDictionary* mutableSubCat = [NSMutableDictionary dictionaryWithDictionary:subCat];
            [mutableSubCat setValue:self.categoryID forKey:@"ParentCategoryID"];
            [mutableSubCat setValue:self.taxYear forKey:@"TaxYear"];
            [mutableSubCat setValue:catPath forKey:@"Path"];
            
            int subcatID = [[subCat objectForKey:@"ID"] intValue];
            
            Category* newCat = [Category newCategoryForCategoryID:subcatID];
            [newCat populateWithDictionary:mutableSubCat];
            
            [subcatSet addObject:newCat];
        }
        
        [self addCategories:subcatSet];
    }

    NSArray* items = (NSArray*)[info objectForKey:@"Items"];
    if(items != nil && [items count] > 0)
    {
        NSMutableSet* itemSet = [[NSMutableSet alloc] initWithCapacity:[items count]];
        for(NSDictionary* item in items)
        {
            int itemID = [[item objectForKey:@"ID"] intValue];
            
            Item* newItem = [Item getByItemID:itemID]; //Need to change
            
            [newItem populateWithDictionary:item];
            newItem.path = catPath;
            newItem.taxYear = self.taxYear;
            
            [itemSet addObject:newItem];
        }
        
        [self addItems:itemSet];
    }

}

@end
