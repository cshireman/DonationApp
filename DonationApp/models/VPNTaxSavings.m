//
//  VPNTaxSavings.m
//  DonationApp
//
//  Created by Chris Shireman on 10/25/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNTaxSavings.h"
#import "VPNAppDelegate.h"
#import "VPNItemList.h"
#import "VPNCashList.h"
#import "VPNMileageList.h"
#import "VPNUser.h"

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

+(void) updateTaxSavings
{
    VPNUser* user = [VPNUser currentUser];
    
    NSArray* itemLists = [VPNItemList loadItemListsFromDisc:user.selected_tax_year];
    NSArray* cashLists = [VPNCashList loadCashListsFromDisc:user.selected_tax_year];
    NSArray* mileageLists = [VPNMileageList loadMileageListsFromDisc:user.selected_tax_year];
    
    double itemsTotal = 0.00;
    double cashTotal = 0.00;
    double mileageTotal = 0.00;
    
    for(VPNItemList* itemList in itemLists)
    {
        itemsTotal += [itemList totalForItems];
    }
    
    for(VPNCashList* cashList in cashLists)
    {
        cashTotal += [cashList.cashDonation doubleValue];
    }
    
    for(VPNMileageList* mileageList in mileageLists)
    {
        mileageTotal += [mileageList.mileage doubleValue];
    }
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* taxRateString = [userDefaults objectForKey:kSelectedTaxRateKey];
    
    double taxRate = [VPNTaxSavings doubleForTaxRate:taxRateString];
    double taxSavings = [VPNTaxSavings calculateTaxSavingsWithItemAmount:itemsTotal moneyAmount:cashTotal mileageAmount:mileageTotal taxRate:taxRate];
    
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.currentTaxSavings = taxSavings;
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
