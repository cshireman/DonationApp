//
//  VPNItemConditionCell.m
//  DonationApp
//
//  Created by Chris Shireman on 12/28/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNItemConditionCell.h"

@implementation VPNItemConditionCell

@synthesize delegate;
@synthesize indexPath;

@synthesize quantityField;
@synthesize fmvLabel;
@synthesize conditionLabel;

+(UINib*) nib
{
    NSBundle* classBundle = [NSBundle bundleForClass:[self class]];
    return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(NSString*) nibName
{
    return @"VPNItemConditionCell";
}

+(id) cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib
{
    NSString* cellID = @"VPNItemConditionCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        NSArray* nibObjects = [nib instantiateWithOwner:nil options:nil];
        
        NSAssert2(([nibObjects count] > 0) && [[nibObjects objectAtIndex:0] isKindOfClass:[self class]], @"Nib '%@' does not appear to contain a valid %@", [self nibName], NSStringFromClass([self class]));
        
        cell = [nibObjects objectAtIndex:0];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setQuantity:(int)quantity
{
    if(quantity != 0)
        quantityField.text = [NSString stringWithFormat:@"%d",quantity];
    else
        quantityField.text = @"";
}

-(void) setFMV:(double)fmv
{
    fmvLabel.text = [NSString stringWithFormat:@"$%.02f",fmv];
}

-(void) setConditionText:(NSString*)conditionText
{
    conditionLabel.text = conditionText;
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL) textField:(UITextField *)localTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* text = localTextField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    
    [delegate quantityUpdated:[text intValue] atIndexPath:indexPath];
    
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)localTextField
{
    [delegate quantityField:localTextField focusedAtIndexPath:indexPath];
}


@end
