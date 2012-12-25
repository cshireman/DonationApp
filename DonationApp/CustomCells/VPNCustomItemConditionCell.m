//
//  VPNCustomItemConditionCell.m
//  DonationApp
//
//  Created by Chris Shireman on 12/20/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNCustomItemConditionCell.h"

@implementation VPNCustomItemConditionCell

@synthesize delegate;
@synthesize indexPath;

@synthesize quantityField;
@synthesize fmvField;
@synthesize conditionLabel;

+(UINib*) nib
{
    NSBundle* classBundle = [NSBundle bundleForClass:[self class]];
    return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(NSString*) nibName
{
    return @"VPNCustomItemConditionCell";
}

+(id) cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib
{
    NSString* cellID = @"VPNCustomItemConditionCell";
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
    if(fmv != 0.00)
        fmvField.text = [NSString stringWithFormat:@"%.02f",fmv];
    else
        fmvField.text = @"";
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
    
    if(localTextField == quantityField)
        [delegate quantityUpdated:[text intValue] atIndexPath:indexPath];
    else if(localTextField == fmvField)
        [delegate fmvUpdated:[text doubleValue] atIndexPath:indexPath];
    
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)localTextField
{
    if(localTextField == quantityField)
        [delegate quantityField:localTextField focusedAtIndexPath:indexPath];
    else if(localTextField == fmvField)
        [delegate fmvField:localTextField focusedAtIndexPath:indexPath];
}


@end
