//
//  VPNContactInfoCell.m
//  DonationApp
//
//  Created by Chris Shireman on 11/19/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNContactInfoCell.h"

@implementation VPNContactInfoCell
@synthesize nameField;
@synthesize emailField;

@synthesize delegate;
@synthesize indexPath;

+(UINib*) nib
{
    NSBundle* classBundle = [NSBundle bundleForClass:[self class]];
    return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(NSString*) nibName
{
    return @"VPNContactInfoCell";
}

+(id) cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib
{
    NSString* cellID = @"VPNContactInfoCell";
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
        if(nameField == nil)
            nameField = [[UITextField alloc] init];
        
        if(emailField == nil)
            emailField = [[UITextField alloc] init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) assignNameText:(NSString*)text
{
    nameField.text = text;
}

-(void) assignEmailText:(NSString*)text
{
    emailField.text = text;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == nameField)
        [delegate nameField:textField focusedAtIndexPath:indexPath];
    else if(textField == emailField)
        [delegate emailField:textField focusedAtIndexPath:indexPath];
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField == nameField)
        [delegate nameFieldUpdatedWithText:text atIndexPath:indexPath];
    else if(textField == emailField)
        [delegate emailFieldUpdatedWithText:text atIndexPath:indexPath];
    
    return YES;
    
}

@end
