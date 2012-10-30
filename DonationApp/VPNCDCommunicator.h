//
//  VPNCDCommunicator.h
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNUser.h"

@interface VPNCDCommunicator : NSObject

-(void)startSessionForUser:(VPNUser*)user;

@end
