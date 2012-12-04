//
//  ItemValue.h
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface ItemValue : NSManagedObject

@property (nonatomic, retain) NSNumber * condition;
@property (nonatomic, retain) NSNumber * valuation;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Item *item;

@end
