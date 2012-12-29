//
//  VPNItemConditionCellDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 12/28/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPNItemConditionCellDelegate <NSObject>

-(void) quantityUpdated:(int)quantity atIndexPath:(NSIndexPath*)indexPath;
-(void) quantityField:(UITextField*)quantityField focusedAtIndexPath:(NSIndexPath*)indexPath;

@end
