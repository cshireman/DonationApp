//
//  VPNDonationListGroup.h
//  DonationApp
//
//  Created by Chris Shireman on 12/13/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNDonationList.h"
#import "VPNOrganization.h"

@interface VPNDonationListGroup : NSObject

@property (assign) int listType;
@property (strong, nonatomic) NSMutableArray* donationLists;
@property (strong, nonatomic) VPNOrganization* organization;

@property (strong, nonatomic, readonly) NSDate* lastDonationDate;

-(double) totalForAllLists;

-(void) addDonationList:(VPNDonationList*)listToAdd;
-(void) removeDonationList:(VPNDonationList*)listToRemove;

@end
