//
//  VPNEditCustomItemDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 12/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VPNItemGroup;
@protocol VPNEditCustomItemDelegate <NSObject>

@optional
-(void) itemGroupAdded:(VPNItemGroup*) addedGroup;
-(void) itemGroupUpdated:(VPNItemGroup*) updatedGroup;

@end
