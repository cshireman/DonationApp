//
//  VPNPasswordCellDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 1/8/13.
//  Copyright (c) 2013 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPNPasswordCellDelegate <NSObject>

@required;
-(void) passwordFieldUpdatedWithText:(NSString*)text atIndexPath:(NSIndexPath*)indexPath;
-(void) passwordField:(UITextField*)textField focusedAtIndexPath:(NSIndexPath*)indexPath;

-(void) confirmPasswordFieldUpdatedWithText:(NSString*)text atIndexPath:(NSIndexPath*)indexPath;
-(void) confirmPasswordField:(UITextField*)textField focusedAtIndexPath:(NSIndexPath*)indexPath;

@end
