//
//  VPNSelectTaxRateViewControllerTest.h
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VPNSelectTaxRateViewController.h"

@interface VPNSelectTaxRateViewControllerTest : SenTestCase <VPNSelectTaxRateViewControllerDelegate>

@property (strong, nonatomic) VPNSelectTaxRateViewController* selectTaxRateController;
@property BOOL cancelPushed;
@property BOOL savePushed;
@property (strong,nonatomic) NSMutableArray* taxRates;
@property (copy, nonatomic) NSString* defaultTaxRate;

-(void) selectTaxRateCanceled;
-(void) selectTaxRateSaved;

@end
