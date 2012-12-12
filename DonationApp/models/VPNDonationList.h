//
//  VPNDonationList.h
//  DonationApp
//
//  Created by Chris Shireman on 12/6/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPNDonationList : NSObject

@property (assign) int ID;
@property (assign) int listType;

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


-(NSMutableDictionary*)toDictionary;

@end
