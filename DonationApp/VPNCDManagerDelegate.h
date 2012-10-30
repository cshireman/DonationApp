//
//  VPNCDManagerDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNUser.h"

@protocol VPNCDManagerDelegate <NSObject>

-(void) startingSessionFailedWithError:(NSError*)error;
-(void) didStartSessionWithUser:(VPNUser*)user;

@end
