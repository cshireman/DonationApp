//
//  VPNDonationList.h
//  DonationApp
//
//  Created by Chris Shireman on 12/6/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ItemList = 0,
    CashList = 1,
    MileageList = 2
    
} DonationListType;

@interface VPNDonationList : NSObject <NSCoding,NSCopying>

@property (assign) int ID;
@property (assign) DonationListType listType;

@property (assign) int companyID;

@property (nonatomic, strong) NSDate* creationDate;
@property (nonatomic, strong) NSDate* donationDate;

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* dateAquired;
@property (nonatomic, copy) NSString* howAquired;

@property (nonatomic, strong) NSNumber* costBasis;
@property (nonatomic, strong) NSNumber* cashDonation;
@property (nonatomic, strong) NSNumber* mileage;

@property (nonatomic, copy) NSString* notes;
@property (nonatomic, strong) NSMutableArray* items;

+(void) removeDonationListFromGlobalList:(VPNDonationList*)listToRemove;

-(NSMutableDictionary*)toDictionary;
-(double) totalForItems;


@end
