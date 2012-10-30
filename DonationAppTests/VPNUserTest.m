//
//  VPNUserTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNUserTest.h"

@implementation VPNUserTest

-(void) setUp
{
    testUser = [[VPNUser alloc] init];
    testUser.username = @"chris@shireman.net";
    testUser.password = @"password";
    testUser.first_name = @"Christopher";
    testUser.last_name = @"Shireman";
}

-(void) tearDown
{
    [VPNUser deleteUserFromDisc];
    testUser = nil;
}

-(void) testCanCreateUser
{
    STAssertNotNil(testUser, @"Should be able to create user");
}

-(void) testUserCanBeSavedToDisc
{
    [testUser saveAsDefaultUser];
    
    VPNUser* loadedUser = [VPNUser loadUserFromDisc];
    STAssertNotNil(loadedUser, @"User should not be nill after being loaded from disc");
    STAssertEqualObjects(loadedUser.username, testUser.username, @"Users are not the same after save");
}

-(void) testUserCanBeDeletedFromDisc
{
    [VPNUser deleteUserFromDisc];
    VPNUser* loadedUser = [VPNUser loadUserFromDisc];
    STAssertNil(loadedUser, @"User should be nill after being loaded from disc");
}

-(void) testUserCanBeAuthenticatedAgainstCurrentUser
{
    [testUser saveAsDefaultUser];
    
    VPNUser* anotherUser = [testUser copy];
    BOOL authenticated = [anotherUser authenticate];
    STAssertTrue(authenticated, @"User copy could not be authenticated");
}

@end
