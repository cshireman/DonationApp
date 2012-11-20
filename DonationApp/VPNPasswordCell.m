//
//  VPNPasswordCell.m
//  DonationApp
//
//  Created by Chris Shireman on 11/19/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNPasswordCell.h"

@implementation VPNPasswordCell
@synthesize passwordField;
@synthesize confirmPasswordField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if(passwordField == nil)
            passwordField = [[UITextField alloc] init];

        if(confirmPasswordField == nil)
            confirmPasswordField = [[UITextField alloc] init];
        
        [passwordField setSecureTextEntry:YES];
        [confirmPasswordField setSecureTextEntry:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
