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


-(NSMutableDictionary*)toDictionary;

@end
