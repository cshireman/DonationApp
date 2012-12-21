//
//  VPNModalPickerView.m
//  DonationApp
//
//  Created by Chris Shireman on 12/20/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNModalPickerView.h"

@implementation VPNModalPickerView

@synthesize picker;
@synthesize doneButton;
@synthesize options;
@synthesize delegate;
@synthesize isShowing;
@synthesize selectedIndex;

+(NSString*) nibName
{
    return @"VPNModalPickerView";
}

- (id)initWithNibName:(NSString*)nibName
{
    NSBundle* classBundle = [NSBundle bundleForClass:[self class]];
    UINib* nib= [UINib nibWithNibName:nibName bundle:classBundle];

    NSArray* nibObjects = [nib instantiateWithOwner:nil options:nil];
    
    NSAssert2(([nibObjects count] > 0) && [[nibObjects objectAtIndex:0] isKindOfClass:[self class]], @"Nib '%@' does not appear to contain a valid %@", [VPNModalPickerView nibName], NSStringFromClass([self class]));
    
    self = [nibObjects objectAtIndex:0];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

*/

-(IBAction) donePushed:(id)sender
{
    [self hide];
}

-(void) show
{
    //Show picker view
    if(!isShowing)
    {
        [picker selectRow:selectedIndex inComponent:0 animated:NO];
        
        isShowing = YES;
        [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect frame = self.frame;
            frame.origin.y -= (frame.size.height);
            
            self.frame = frame;
        }
         completion:^(BOOL finished){
             [delegate pickerWasDisplayed];
         }];
    }
}

-(void) hide
{
    //Show picker view
    if(isShowing)
    {
        isShowing = NO;
        [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect frame = self.frame;
            frame.origin.y += (frame.size.height);
            
            self.frame = frame;
        }
             completion:^(BOOL finished){
                 [delegate pickerWasDismissed];
             }];
    }
    
}

-(void) addToView:(UIView*)view
{
    CGRect frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.frame = frame;
    [view addSubview:self];
    [view bringSubviewToFront:self];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    id selectedObject = [options objectAtIndex:row];
    NSLog(@"Changing selection to %@",selectedObject);
    [delegate optionWasSelectedAtIndex:row];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[options objectAtIndex:row] description];
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [options count];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
