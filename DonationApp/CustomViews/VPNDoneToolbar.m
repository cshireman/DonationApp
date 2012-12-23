//
//  VPNDoneToolbar.m
//  DonationApp
//
//  Created by Chris Shireman on 12/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNDoneToolbar.h"

@implementation VPNDoneToolbar
@synthesize delegate;
@synthesize doneButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(UINib*) nib
{
    NSBundle* classBundle = [NSBundle bundleForClass:[self class]];
    return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(NSString*) nibName
{
    return @"VPNDoneToolbar";
}

+(id) doneToolbarFromFromNib:(UINib*)nib
{
    NSArray* nibObjects = [nib instantiateWithOwner:nil options:nil];
    
    NSAssert2(([nibObjects count] > 0) && [[nibObjects objectAtIndex:0] isKindOfClass:[self class]], @"Nib '%@' does not appear to contain a valid %@", [self nibName], NSStringFromClass([self class]));
    
    return [nibObjects objectAtIndex:0];
}

-(IBAction) donePushed:(id)sender
{
    [delegate doneToolbarButtonPushed:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
