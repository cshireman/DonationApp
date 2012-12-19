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

typedef enum
{
    Fair=0,
    Good=1,
    VeryGood=2,
    Excellent=3,
    Mint=4
} ItemCondition;

typedef enum
{
    Other=1,
    OnlineAuction=2,
    ComparableSales=3,
    ThriftStore=4
} ItemValuation;

@interface VPNItem : NSObject <NSCoding, NSCopying>

@property (assign) int ID;

@property (strong, nonatomic) NSDate* creationDate;

@property (assign) ItemCondition condition;
@property (assign) ItemValuation valuation;
@property (assign) int categoryID;
@property (assign) int itemID;

@property (strong, nonatomic) NSString* name;

@property (assign) int quantity;

@property (strong, nonatomic) NSNumber* fairMarketValue;

@property (assign) BOOL isCustomItem;
@property (assign) BOOL isCustomValue;

@property (strong, nonatomic) NSString* notes;

-(id) initWithDictionary:(NSDictionary*)info;

-(NSDictionary*) toDictionary;

@end
