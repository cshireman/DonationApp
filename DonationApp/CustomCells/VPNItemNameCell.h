//
//  VPNItemNameCell.h
//  DonationApp
//
//  Created by Chris Shireman on 12/23/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNItemNameCellDelegate.h"

@interface VPNItemNameCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) id<VPNItemNameCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath* indexPath;

@property (strong, nonatomic) IBOutlet UITextField* textField;

+(UINib*) nib;
+(NSString*) nibName;
+(id) cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib;

-(void) setText:(NSString*)text;

@end
