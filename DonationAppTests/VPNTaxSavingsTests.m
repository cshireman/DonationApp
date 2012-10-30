//
//  VPNTaxSavingsTests.m
//  DonationApp
//
//  Created by Chris Shireman on 10/25/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNTaxSavingsTests.h"

@implementation VPNTaxSavingsTests

-(void) setUp
{
    [super setUp];
}

-(void) tearDown
{
    [super tearDown];
}

-(void) testTaxSavingsCalculationWorksForItemOnlyDonation
{
    double itemAmount = 100.00;
    double moneyAmount = 0.00;
    double mileageAmount = 0.00;
    double taxRate = 0.15;
    
    double answer = 15.00;
    double result = [VPNTaxSavings calculateTaxSavingsWithItemAmount:itemAmount moneyAmount:moneyAmount mileageAmount:mileageAmount taxRate:taxRate];
    
    STAssertEquals(result, answer, @"Tax Savings calculation doesn't produce correct result");
}

-(void) testTaxSavingsCalculationWorksForMoneyOnlyDonation
{
    double itemAmount = 0.00;
    double moneyAmount = 200.00;
    double mileageAmount = 0.00;
    double taxRate = 0.15;
    
    double answer = 30.00;
    double result = [VPNTaxSavings calculateTaxSavingsWithItemAmount:itemAmount moneyAmount:moneyAmount mileageAmount:mileageAmount taxRate:taxRate];
    
    STAssertEquals(result, answer, @"Tax Savings calculation doesn't produce correct result");
}

-(void) testTaxSavingsCanConvertSettingsStringToDouble
{
    double taxRate = [VPNTaxSavings doubleForTaxRate:@"15%"];
    STAssertEquals(taxRate, 0.15, @"Tax rate conversion should result in 0.15");
    
    taxRate = [VPNTaxSavings doubleForTaxRate:@"25%"];
    STAssertEquals(taxRate, 0.25, @"Tax rate conversion should result in 0.25");
}

@end
