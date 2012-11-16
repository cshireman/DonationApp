//
//  VPNMainTabGroupControllerTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNMainTabGroupControllerTest.h"

@implementation VPNMainTabGroupControllerTest

-(void) setUp
{
    tabGroupController = [[VPNMainTabGroupViewController alloc] init];
}

-(void) tearDown
{
    tabGroupController = nil;
}

-(void) testNoSelectedTaxYearTriggersSelectTaxYearSegue
{
    VPNUser* user = [VPNUser currentUser];
    user.selected_tax_year = 0;
    
    id mockController = [OCMockObject partialMockForObject:tabGroupController];
    
    [[mockController expect] performSegueWithIdentifier:@"SelectTaxYearSegue" sender:tabGroupController];
    [[mockController stub] performSegueWithIdentifier:[OCMArg any] sender:[OCMArg any]];
    
    [tabGroupController loginControllerFinished];
    
    [mockController verify];
}

@end
