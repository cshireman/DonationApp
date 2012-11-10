//
//  VPNOrganizationsListViewControllerTests.m
//  DonationApp
//
//  Created by Chris Shireman on 11/5/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNOrganizationsListViewControllerTests.h"
#import "VPNOrganizationListViewController.h"

@implementation VPNOrganizationsListViewControllerTests

-(void) setUp
{
    orgListController = [[VPNOrganizationListViewController alloc] init];
    orgs = [[NSMutableArray alloc] initWithCapacity:2];
}

-(void) tearDown
{
    orgListController = nil;
    orgs = nil;
}

-(void) testNumberOfRowsMatchesNumberOfOrgs
{
    [orgs addObject:@"Org 1"];
    [orgs addObject:@"Org 2"];
    
    orgListController.organizations = orgs;
    
    NSInteger numberOfRows = [orgListController tableView:nil numberOfRowsInSection:0];
    
    STAssertEquals(2, numberOfRows, @"There should be only 2 rows in the table");
}

-(void) testRowWillDisplayOrgInformation
{
    VPNOrganization* org = [[VPNOrganization alloc] init];
    
    org.ID = 1;
    org.name = @"Test Org";
    org.address = @"Address";
    org.city = @"City";
    org.state = @"State";
    org.zip_code = @"12345";
    
    [orgs addObject:org];
    
    orgListController.organizations = orgs;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    VPNOrganizationCell* cell = (VPNOrganizationCell*)[orgListController tableView:nil cellForRowAtIndexPath:indexPath];
    
    STAssertEqualObjects(cell.nameLabel.text, @"Test Org", @"Name label should have been set");
    STAssertEqualObjects(cell.addressLabel.text, @"Address", @"Address label should have been set");
    STAssertEqualObjects(cell.localityLabel.text, @"City, State 12345", @"Locality label should have been set");
}

-(void) testTouchingEditWillPutTableViewInEditMode
{
    [orgListController.tableView setEditing:NO];
    
    [orgListController editPushed];
    STAssertTrue(orgListController.tableView.editing,@"Table View should have been put into edit mode");
}

-(void) testTouchingEditWillTakeTableViewOutOfEditMode
{
    [orgListController.tableView setEditing:YES];
    
    [orgListController editPushed];
    STAssertFalse(orgListController.tableView.editing,@"Table View should have been put into edit mode");
}

-(void) testDeletingRowInTableDeletedOrganization
{
    VPNOrganization* org = [[VPNOrganization alloc] init];
    VPNOrganization* org2 = [[VPNOrganization alloc] init];
    
    org.ID = 1;
    org2.ID = 2;

    [orgs addObject:org];
    [orgs addObject:org2];
    
    orgListController.organizations = orgs;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [orgListController tableView:nil commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    
    STAssertEquals(1, (NSInteger)[orgs count], @"There should only be one org left");
    STAssertEquals(2, [(VPNOrganization*)[orgs objectAtIndex:0] ID], @"The 2nd org should remain");
}

-(void) testViewDidLoadCreatesManager
{
    [orgListController viewDidLoad];
    STAssertNotNil(orgListController.manager, @"Manager should have been created");
}

-(void) testDoesLoadOrganizationsFromManagerWhenViewAppears
{
    id mockManager = [OCMockObject mockForClass:[VPNCDManager class]];
    
    [[mockManager expect] getOrganizations:NO];
    
    orgListController.manager = mockManager;
    [orgListController viewWillAppear:YES];
    
    [mockManager verify];
}


@end
