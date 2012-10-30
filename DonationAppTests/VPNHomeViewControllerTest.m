//
//  VPNHomeViewControllerTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNHomeViewControllerTest.h"

@implementation VPNHomeViewControllerTest
@synthesize homeController;

-(void) setUp
{
    [super setUp];
    self.homeController = [[VPNHomeViewController alloc] init];
}

/*
-(void) testTaxSavingsIsUpdatedAfterNewTaxRateIsSelected
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setDouble:10.00 forKey:kTaxSavingsKey];
    [userDefaults setDouble:100.00 forKey:kItemSubtotalKey];
    [userDefaults setDouble:0.00 forKey:kMoneySubtotalKey];
    [userDefaults setDouble:0.00 forKey:kMileageSubtotalKey];
    
    [userDefaults setValue:@"25%" forKey:kSelectedTaxRateKey];
    [userDefaults synchronize];
    
    [self.homeController selectTaxRateSaved];
    
    [userDefaults synchronize];
    STAssertEquals(25.00, [userDefaults doubleForKey:kTaxSavingsKey], @"Tax savings should have been updated to 25.00");
    
    [userDefaults setValue:@"15%" forKey:kSelectedTaxRateKey];
    [userDefaults synchronize];
    
    [self.homeController selectTaxRateSaved];
    
    [userDefaults synchronize];
    STAssertEquals(15.00, [userDefaults doubleForKey:kTaxSavingsKey], @"Tax savings should have been updated to 15.00");

}
 */



@end

