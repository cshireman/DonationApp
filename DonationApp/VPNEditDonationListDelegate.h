//
//  VPNEditDonationListDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 12/17/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNDonationList.h"

@protocol VPNEditDonationListDelegate <NSObject>

@required

-(void) didFinishEditingDonationList:(VPNDonationList*)donationList;

@end
