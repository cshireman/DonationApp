//
//  Category.h
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Item;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber * categoryID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * path;

@property (nonatomic, retain) NSNumber * taxYear;
@property (nonatomic, retain) NSNumber * parentCategoryID;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSSet *items;

+(Category*) loadCategoryForID:(int)categoryID;
+(NSArray*) loadCategoriesForCategoryID:(int)categoryID;
+(NSArray*) keywordSearch:(NSString*)keyword;

-(NSString*) description;

@end

@interface Category (CoreDataGeneratedAccessors)


- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
