//
//  VPNPasswordCell.h
//  DonationApp
//
//  Created by Chris Shireman on 11/19/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPNPasswordCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField* passwordField;
@property (strong, nonatomic) IBOutlet UITextField* confirmPasswordField;

@end
