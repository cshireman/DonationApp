//
//  VPNItemNameCell.m
//  DonationApp
//
//  Created by Chris Shireman on 12/23/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNItemNameCell.h"

@implementation VPNItemNameCell

@synthesize delegate;
@synthesize textField;
@synthesize indexPath;

+(UINib*) nib
{
    NSBundle* classBundle = [NSBundle bundleForClass:[self class]];
    return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(NSString*) nibName
{
    return @"VPNItemNameCell";
}

+(id) cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib
{
    NSString* cellID = @"VPNItemNameCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        NSArray* nibObjects = [nib instantiateWithOwner:nil options:nil];
        NSLog(@"Class from nib:%@",NSStringFromClass([[nibObjects objectAtIndex:0] class]));
        
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

-(void) setText:(NSString*)text
{
    textField.text = text;
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL) textField:(UITextField *)localTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* text = localTextField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    
    [delegate itemNameFieldUpdatedWithText:text atIndexPath:indexPath];
    
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)localTextField
{
    [delegate itemNameField:localTextField focusedAtIndexPath:indexPath];
}

@end
