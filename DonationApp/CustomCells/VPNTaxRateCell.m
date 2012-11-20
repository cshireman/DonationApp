//
//  VPNTaxRateCell.m
//  DonationApp
//
//  Created by Chris Shireman on 11/19/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNTaxRateCell.h"

@implementation VPNTaxRateCell
@synthesize taxSavings;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if(taxSavings == nil)
            taxSavings = [[UILabel alloc] init];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
