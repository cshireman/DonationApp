//
//  VPNItemList.h
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNDonationList.h"
#import "VPNNotifier.h"

#define kItemListsFilePath  @"itemLists"

#define kItemListsIDKey                 @"ID"
#define kItemListsListTypeKey           @"ListType"
#define kItemListsCompanyIDKey          @"CompanyID"
#define kItemListsCreationDateKey       @"CreationDate"
#define kItemListsDonationDateKey       @"DonationDate"
#define kItemListsNameKey               @"Name"
#define kItemListsDateAquiredKey        @"DateAquired"
#define kItemListsHowAquiredKey         @"HowAquired"
#define kItemListsCostBasisKey          @"CostBasis"
#define kItemListsNotesKey              @"Notes"
#define kItemListsItemsKey              @"Items"

#define kItemListSourcePurchased        @"I purchased them"
#define kItemListSourceGift             @"They were a gift"
#define kItemListSourceInherited        @"I inherited them"
#define kItemListSourceExchanged        @"I exchanged them"

@interface VPNItemList : VPNDonationList <NSCoding>

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* dateAquired;
@property (nonatomic, copy) NSString* howAquired;

@property (nonatomic, strong) NSNumber* costBasis;
@property (nonatomic, copy) NSString* notes;
@property (nonatomic, strong) NSMutableArray* items;

+(NSMutableArray*) loadItemListsFromDisc:(int)taxYear;
+(void) saveItemListsToDisc:(NSArray*)itemLists forTaxYear:(int)taxYear;
+(NSString*) itemListsFilePath:(int)taxYear;

-(id) initWithDictionary:(NSDictionary*)info;

-(double) totalForItems;

@end
