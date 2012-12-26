//
//  VPNItemGroupDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 12/26/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPNItemGroupDelegate <NSObject>

-(void) didFinishSavingItemGroup;
-(void) saveFailedWithError:(NSError*)error;

@end
