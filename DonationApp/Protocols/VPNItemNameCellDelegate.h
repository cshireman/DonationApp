//
//  VPNItemNameCellDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 12/23/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPNItemNameCellDelegate <NSObject>

@required;
-(void) itemNameFieldUpdatedWithText:(NSString*)text atIndexPath:(NSIndexPath*)indexPath;
-(void) itemNameField:(UITextField*)itemNameField focusedAtIndexPath:(NSIndexPath*)indexPath;



@end
