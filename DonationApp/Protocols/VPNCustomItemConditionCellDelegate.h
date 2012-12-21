//
//  VPNCustomItemConditionCellDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 12/20/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPNCustomItemConditionCellDelegate <NSObject>

@required;
-(void) quantityUpdated:(int)quantity atIndexPath:(NSIndexPath*)indexPath;
-(void) fmvUpdated:(double)fmv atIndexPath:(NSIndexPath*)indexPath;

@end
