//
//  VPNCommunicatorDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 10/31/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPNCommunicatorDelegate <NSObject>

@optional
-(void) receivedUserJSON:(NSString*)objectNotation;
-(void) receivedSessionJSON:(NSString*)objectNotation;

-(void) receivedError:(NSError*)error;

@end
