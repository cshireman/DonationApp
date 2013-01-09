//
//  VPNPasswordCell.h
//  DonationApp
//
//  Created by Chris Shireman on 11/19/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNPasswordCellDelegate.h"

@interface VPNPasswordCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField* passwordField;
@property (strong, nonatomic) IBOutlet UITextField* confirmPasswordField;

@property (weak, nonatomic) id<VPNPasswordCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath* indexPath;

+(UINib*) nib;
+(NSString*) nibName;
+(id) cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib;

-(void) assignPasswordText:(NSString*)text;
-(void) assignConfirmPasswordText:(NSString*)text;

@end
