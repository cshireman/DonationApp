//
//  VPNTaxSavings.h
//  DonationApp
//
//  Created by Chris Shireman on 10/25/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSelectedTaxRateKey     @"selected_tax_rate"


@interface VPNTaxSavings : NSObject

@property (assign) double itemSubtotal;
@property (assign) double moneySubtotal;
@property (assign) double mileageSubtotal;
@property (assign) double taxSavings;
@property (assign) double taxRate;

+(double) calculateTaxSavingsWithItemAmount:(double)itemAmount moneyAmount:(double)moneyAmount mileageAmount:(double)mileageAmount taxRate:(double)taxRate;
+(double) doubleForTaxRate:(NSString*)taxRate;
+(double) currentTaxSavings;
+(void) updateTaxSavings;

@end
