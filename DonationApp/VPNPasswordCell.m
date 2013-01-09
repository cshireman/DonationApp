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
@synthesize delegate;
@synthesize indexPath;

+(UINib*) nib
{
    NSBundle* classBundle = [NSBundle bundleForClass:[self class]];
    return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(NSString*) nibName
{
    return @"VPNPasswordCell";
}

+(id) cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib
{
    NSString* cellID = @"VPNPasswordCell";
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

-(void) assignPasswordText:(NSString*)text
{
    passwordField.text = text;
}

-(void) assignConfirmPasswordText:(NSString*)text
{
    confirmPasswordField.text = text;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == passwordField)
        [delegate passwordField:textField focusedAtIndexPath:indexPath];
    else if(textField == confirmPasswordField)
        [delegate confirmPasswordField:textField focusedAtIndexPath:indexPath];
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField == passwordField)
        [delegate passwordFieldUpdatedWithText:text atIndexPath:indexPath];
    else if(textField == confirmPasswordField)
        [delegate confirmPasswordFieldUpdatedWithText:text atIndexPath:indexPath];
    
    return YES;
}


@end
