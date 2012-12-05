//
//  VPNItem.h
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kVPNItemIDKey                   @"ID"
#define kVPNItemCreationDateKey         @"CreationDate"
#define kVPNItemConditionKey            @"Condition"
#define kVPNItemValuationKey            @"Valuation"
#define kVPNItemCategoryIDKey           @"CategoryID"
#define kVPNItemItemIDKey               @"ItemID"
#define kVPNItemNameKey                 @"Name"
#define kVPNItemQuantityKey             @"Quantity"
#define kVPNItemFairMarketValueKey      @"FairMarketValue"
#define kVPNItemIsCustomItemKey         @"IsCustomItem"
#define kVPNItemIsCustomValueKey        @"IsCustomValue"
#define kVPNItemNotesKey                @"Notes"


@interface VPNItem : NSObject <NSCoding>

@property (assign) int ID;

@property (strong, nonatomic) NSDate* creationDate;

@property (assign) int condition;
@property (assign) int valuation;
@property (assign) int categoryID;
@property (assign) int itemID;

@property (strong, nonatomic) NSString* name;

@property (assign) int quantity;

@property (strong, nonatomic) NSNumber* fairMarketValue;

@property (assign) BOOL isCustomItem;
@property (assign) BOOL isCustomValue;

@property (strong, nonatomic) NSString* notes;

-(id) initWithDictionary:(NSDictionary*)info;

@end
