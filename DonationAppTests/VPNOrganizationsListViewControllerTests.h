//
//  VPNOrganizationsListViewControllerTests.h
//  DonationApp
//
//  Created by Chris Shireman on 11/5/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VPNOrganizationListViewController.h"
#import "VPNOrganization.h"
#import "VPNOrganizationCell.h"
#import "VPNCDManager.h"
#import "OCMock.h"

@interface VPNOrganizationsListViewControllerTests : SenTestCase
{
    VPNOrganizationListViewController* orgListController;
    NSMutableArray* orgs;
}


@end
