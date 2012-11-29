//
//  VPNCashList.h
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNNotifier.h"

#define kCashListsFilePath  @"cashLists"

#define kCashListsIDKey                 @"ID"
#define kCashListsListTypeKey           @"ListType"
#define kCashListsCompanyIDKey          @"CompanyID"
#define kCashListsCreationDateKey       @"CreationDate"
#define kCashListsDonationDateKey       @"DonationDate"
#define kCashListsNameKey               @"Name"
#define kCashListsCashDonationKey       @"CashDonation"
#define kCashListsNotesKey              @"Notes"

@interface VPNCashList : NSObject <NSCoding>

@property (assign) int ID;
@property (assign) int listType;
@property (assign) int companyID;

@property (nonatomic, strong) NSDate* creationDate;
@property (nonatomic, strong) NSDate* donationDate;

@property (nonatomic, copy) NSString* name;

@property (nonatomic, strong) NSNumber* cashDonation;
@property (nonatomic, copy) NSString* notes;


+(NSMutableArray*) loadCashListsFromDisc:(int)taxYear;
+(void) saveCashListsToDisc:(NSArray*)organizations forTaxYear:(int)taxYear;
+(NSString*) cashListsFilePath:(int)taxYear;

-(id) initWithDictionary:(NSDictionary*)info;

@end
