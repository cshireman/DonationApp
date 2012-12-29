//
//  VPNItemConditionCell.h
//  DonationApp
//
//  Created by Chris Shireman on 12/28/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNItemConditionCellDelegate.h"

@interface VPNItemConditionCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) id<VPNItemConditionCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath* indexPath;

@property (strong, nonatomic) IBOutlet UITextField* quantityField;
@property (strong, nonatomic) IBOutlet UILabel* fmvLabel;
@property (strong, nonatomic) IBOutlet UILabel* conditionLabel;

+(UINib*) nib;
+(NSString*) nibName;
+(id) cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib;

-(void) setQuantity:(int)quantity;
-(void) setFMV:(double)fmv;
-(void) setConditionText:(NSString*)conditionText;

@end
