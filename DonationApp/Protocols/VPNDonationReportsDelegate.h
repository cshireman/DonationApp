//
//  VPNDonationReportsDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 12/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPNDonationReportsDelegate <NSObject>

-(void) donationReportsControllerSelectedDonationLists:(NSArray*)donationLists;
-(NSMutableArray*) selectedDonationLists;

@end
