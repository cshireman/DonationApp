//
//  Item.h
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, ItemValue;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * itemID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * taxYear;
@property (nonatomic, retain) NSSet *values;
@property (nonatomic, retain) Category *category;

+(Item*) loadItemForID:(int)itemID;
+(NSArray*) loadItemsForCategoryID:(int)categoryID;
+(NSArray*) keywordSearch:(NSString*)keyword;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addValuesObject:(ItemValue *)value;
- (void)removeValuesObject:(ItemValue *)value;
- (void)addValues:(NSSet *)values;
- (void)removeValues:(NSSet *)values;

@end
