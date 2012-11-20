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
    [VPNUser saveUserToDisc:testUser];
    
    VPNUser* loadedUser = [VPNUser loadUserFromDisc];
    STAssertNotNil(loadedUser, @"User should not be nill after being loaded from disc");
    STAssertEqualObjects(loadedUser.username, testUser.username, @"Users are not the same after save");
    
    [VPNUser deleteUserFromDisc];
}

-(void) testUserCanBeDeletedFromDisc
{
    [VPNUser deleteUserFromDisc];
    VPNUser* loadedUser = [VPNUser loadUserFromDisc];
    STAssertNil(loadedUser, @"User should be nill after being loaded from disc");
}

-(void) testUserCanBeInitializedWithDictionary
{
    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
    
    [userInfo setObject:@"chris@shireman.net" forKey:@"Email"];
    [userInfo setObject:@"Christopher" forKey:@"FirstName"];
    [userInfo setObject:@"Shireman" forKey:@"LastName"];
    [userInfo setObject:@"FALSE" forKey:@"EmailOptOut"];

    VPNUser* user = [[VPNUser alloc] initWithDictionary:userInfo];
    
    STAssertEqualObjects(@"chris@shireman.net", user.email, @"Email should have been initialized from dictionary");
    STAssertEqualObjects(@"Christopher", user.first_name, @"FirstName should have been initialized from dictionary");
    STAssertEqualObjects(@"Shireman", user.last_name, @"LastName should have been initialized from dictionary");
    STAssertEquals(YES, user.is_email_opted_in, @"Email Opt In should have been initialized from dictionary");
}

-(void) testInitUserWithNilDictionaryThrowsError
{
    STAssertThrows([[VPNUser alloc] initWithDictionary:nil],@"Should throw error if dictionary is nil");
}


@end
