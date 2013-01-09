//
//  VPNContactInfoCellDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 1/8/13.
//  Copyright (c) 2013 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPNContactInfoCellDelegate <NSObject>

@required;
-(void) nameFieldUpdatedWithText:(NSString*)text atIndexPath:(NSIndexPath*)indexPath;
-(void) nameField:(UITextField*)textField focusedAtIndexPath:(NSIndexPath*)indexPath;

-(void) emailFieldUpdatedWithText:(NSString*)text atIndexPath:(NSIndexPath*)indexPath;
-(void) emailField:(UITextField*)textField focusedAtIndexPath:(NSIndexPath*)indexPath;

@end
