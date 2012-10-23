//
//  VPNSelectTaxRateViewControllerTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSelectTaxRateViewControllerTest.h"

@implementation VPNSelectTaxRateViewControllerTest
@synthesize selectTaxRateController;
@synthesize cancelPushed;
@synthesize savePushed;

-(void) setUp
{
    self.selectTaxRateController = [[VPNSelectTaxRateViewController alloc] init];
    self.selectTaxRateController.delegate = self;
    
    self.cancelPushed = NO;
    self.savePushed = NO;
}

-(void) testSelectTaxRateControllerCanCancel
{
    [self.selectTaxRateController cancelPushed:self];
    STAssertTrue(self.cancelPushed,@"Cancel should have been pushed");
}

-(void) testSelectTaxRateControllerCanSave
{
    [self.selectTaxRateController savePushed:self];
    STAssertTrue(self.savePushed,@"Save should have been pushed");
}


#pragma mark -
#pragma mark VPNSelectTaxRateControllerDelegate Methods

-(void) selectTaxRateCanceled
{
    self.cancelPushed = YES;
}

-(void) selectTaxRateSaved
{
    self.savePushed = YES;
}


@end
