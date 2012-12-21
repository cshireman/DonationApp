//
//  VPNCustomItemConditionCell.h
//  DonationApp
//
//  Created by Chris Shireman on 12/20/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNCustomItemConditionCellDelegate.h"

@interface VPNCustomItemConditionCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) id<VPNCustomItemConditionCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath* indexPath;

@property (strong, nonatomic) IBOutlet UITextField* quantityField;
@property (strong, nonatomic) IBOutlet UITextField* fmvField;
@property (strong, nonatomic) IBOutlet UILabel* conditionLabel;

+(UINib*) nib;
+(NSString*) nibName;
+(id) cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib;

-(void) setQuantity:(int)quantity;
-(void) setFMV:(double)fmv;
-(void) setConditionText:(NSString*)conditionText;



@end
