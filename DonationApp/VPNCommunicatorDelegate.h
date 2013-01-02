//
//  VPNCommunicatorDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 10/31/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString APICallType;

@protocol VPNCommunicatorDelegate <NSObject>

@optional
-(void) receivedResponse:(NSData*)response forAPICall:(APICallType*)apiCall;
-(void) receivedError:(NSError*)error forAPICall:(APICallType*)apiCall;

@end
