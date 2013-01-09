//
//  VPNContactInfoCell.h
//  DonationApp
//
//  Created by Chris Shireman on 11/19/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNContactInfoCellDelegate.h"

@interface VPNContactInfoCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) id<VPNContactInfoCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath* indexPath;

@property (strong, nonatomic) IBOutlet UITextField* nameField;
@property (strong, nonatomic) IBOutlet UITextField* emailField;

+(UINib*) nib;
+(NSString*) nibName;
+(id) cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib;

-(void) assignNameText:(NSString*)text;
-(void) assignEmailText:(NSString*)text;

@end
