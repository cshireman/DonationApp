//
//  VPNOrganizationTests.m
//  DonationApp
//
//  Created by Chris Shireman on 11/5/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNOrganizationTests.h"

@implementation VPNOrganizationTests

-(void)setUp
{
    organization = [[VPNOrganization alloc] init];
}

-(void)tearDown
{
    organization = nil;
}

-(void)testCanGetOrgInformation
{
    organization.ID = 123;
    organization.is_active = YES;
    organization.name = @"Test Org";
    organization.address = @"Address";

    organization.city = @"City";
    organization.state = @"State";
    organization.zip_code = @"ZipCode";

    organization.list_count = 5;
    
    STAssertEquals(123, organization.ID, @"ID should have been assigned");
    STAssertEquals(YES, organization.is_active, @"Organization should be active");
    STAssertEqualObjects(organization.name, @"Test Org", @"Name should be able to be assigned");
    STAssertEqualObjects(organization.address, @"Address", @"Address should be able to be assigned");
    
    STAssertEqualObjects(organization.city, @"City", @"City should be able to be assigned");
    STAssertEqualObjects(organization.state, @"State", @"State should be able to be assigned");
    STAssertEqualObjects(organization.zip_code, @"ZipCode", @"ZipCode should be able to be assigned");
    
    STAssertEquals(5, organization.list_count, @"List count should have been assigned");
}

@end
