//
//  VPNTaxSavings.m
//  DonationApp
//
//  Created by Chris Shireman on 10/25/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNTaxSavings.h"
#import "VPNAppDelegate.h"

@implementation VPNTaxSavings
@synthesize itemSubtotal;
@synthesize moneySubtotal;
@synthesize mileageSubtotal;
@synthesize taxSavings;
@synthesize taxRate;

/**
 * Calculate the tax savings amount based on donation amounts and tax rate
 */
+(double) calculateTaxSavingsWithItemAmount:(double)itemAmount moneyAmount:(double)moneyAmount mileageAmount:(double)mileageAmount taxRate:(double)taxRate;
{
    return taxRate*(itemAmount+moneyAmount+(0.14*mileageAmount));
}

+(double) doubleForTaxRate:(NSString*)taxRate
{
    if([taxRate isEqualToString:@"10%"])
        return 0.10;
    if([taxRate isEqualToString:@"15%"])
        return 0.15;
    if([taxRate isEqualToString:@"20%"])
        return 0.20;
    if([taxRate isEqualToString:@"25%"])
        return 0.25;
    if([taxRate isEqualToString:@"28%"])
        return 0.28;
    if([taxRate isEqualToString:@"33%"])
        return 0.33;
    if([taxRate isEqualToString:@"35%"])
        return 0.35;
    
    return 0.0;
}

+(double) currentTaxSavings
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    return appDelegate.currentTaxSavings;
}

-(void) setCurrentTaxSavings:(double)newTaxSavings
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.currentTaxSavings = newTaxSavings;
}

@end
