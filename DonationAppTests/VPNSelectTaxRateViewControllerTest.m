//
//  VPNSelectTaxRateViewControllerTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSelectTaxRateViewControllerTest.h"
#import "OCMock.h"
#import "OCMockObject.h"

@implementation VPNSelectTaxRateViewControllerTest
@synthesize selectTaxRateController;
@synthesize cancelPushed;
@synthesize savePushed;
@synthesize taxRates;
@synthesize defaultTaxRate;

-(void) setUp
{
    self.defaultTaxRate = @"25%";
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.defaultTaxRate forKey:kSelectedTaxRateKey];
    
    self.selectTaxRateController = [[VPNSelectTaxRateViewController alloc] init];
    self.selectTaxRateController.delegate = self;
    
    self.cancelPushed = NO;
    self.savePushed = NO;
    self.taxRates = [[NSMutableArray alloc] initWithObjects:@"10%",@"15%",@"25%",@"28%",@"33%",@"35%", nil];

    self.selectTaxRateController.taxRates = self.taxRates;
}

-(void) testSelectTaxRateControllerCanPushCancel
{
    [self.selectTaxRateController cancelPushed:self];
    STAssertTrue(self.cancelPushed,@"Cancel should have been pushed");
}

-(void) testSelectTaxRateControllerCanPushSave
{
    [self.selectTaxRateController savePushed:self];
    STAssertTrue(self.savePushed,@"Save should have been pushed");
}

-(void) testThatTaxRateCellsArePopulated
{
    for(int i = 0; i < [taxRates count]; i++)
    {
        NSIndexPath* taxRateIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        id testTableView = [OCMockObject mockForClass: [UITableView class]];
        [[testTableView expect] dequeueReusableCellWithIdentifier:@"Cell"];
        
        UITableViewCell* testCell = [self.selectTaxRateController tableView:testTableView cellForRowAtIndexPath:taxRateIndexPath];
        STAssertEqualObjects(testCell.textLabel.text, [self.taxRates objectAtIndex:taxRateIndexPath.row], @"Tax Rate label doesn't match");
        [testTableView verify];
    }
}

-(void) testThatThereIsOnlyOneSection
{
    NSInteger testSectionCount = [self.selectTaxRateController numberOfSectionsInTableView:nil];
    STAssertEquals(testSectionCount, 1, @"There can be only one - section that is");
}

-(void) testThatThereAreTheCorrectNumberOfRowsInTheTable
{
    NSUInteger testRowCount = [self.selectTaxRateController tableView:nil numberOfRowsInSection:0];
    STAssertEquals(testRowCount, [self.taxRates count], @"There should be the same number of rows as there are tax rates");
}

-(void) testThatTaxRateCanBeSelected
{
    NSIndexPath* rowIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    
    id testTableView = [OCMockObject mockForClass: [UITableView class]];
    [[testTableView expect] deselectRowAtIndexPath:rowIndexPath animated:YES];
    [[testTableView expect] reloadData];
    
    self.selectTaxRateController.selectedTaxRate = @"25%";
    [self.selectTaxRateController tableView:testTableView didSelectRowAtIndexPath:rowIndexPath];
    
    STAssertEquals(@"28%", self.selectTaxRateController.selectedTaxRate, @"Tax Rate should have changed to 28%");
    [testTableView verify];
}

-(void) testThatTaxRateCanBeSelectedAndSaved
{
    self.selectTaxRateController.selectedTaxRate = @"25%";
    [self.selectTaxRateController tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [self.selectTaxRateController savePushed:self];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* savedTaxRate = [userDefaults objectForKey:kSelectedTaxRateKey];
    STAssertEqualObjects(@"28%", savedTaxRate, @"Tax rate was not saved when save pushed");
}

-(void) testThatSelectedTaxRateWasLoadedFromUserDefaults
{
    STAssertEqualObjects(self.defaultTaxRate, self.selectTaxRateController.selectedTaxRate, @"Tax rate should load as default tax rate");
}

-(void) testCheckmarkIsDisplayedOnSelectedTaxRateRow
{
    id testTableView = [OCMockObject mockForClass: [UITableView class]];
    for(int i = 0; i < [self.taxRates count]; i++)
    {
        if([[self.taxRates objectAtIndex:i] isEqualToString:self.selectTaxRateController.selectedTaxRate])
        {
            NSIndexPath* taxRateIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [[testTableView expect] dequeueReusableCellWithIdentifier:@"Cell"];
        
            UITableViewCell* testCell = [self.selectTaxRateController tableView:testTableView cellForRowAtIndexPath:taxRateIndexPath];
            [testTableView verify];
            STAssertEquals(testCell.accessoryType, UITableViewCellAccessoryCheckmark, @"Selected tax rate should have a check mark");
        }
    }
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
