//
//  VPNUserTest.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNUserTest.h"

@implementation VPNUserTest

-(void) testUserCanBeSavedToDisc
{
    VPNUser* testUser = [[VPNUser alloc] init];
    testUser.username = @"chris@shireman.net";
    testUser.password = @"password";
    testUser.first_name = @"Christopher";
    testUser.last_name = @"Shireman";
    
    [testUser saveAsDefaultUser];
    
    NSString* filename = [VPNUser userFilePath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filename];
    STAssertTrue(fileExists, @"User file doesn't exist!");
    
    VPNUser* loadedUser = [VPNUser loadUserFromDisc];
    STAssertEqualObjects(loadedUser.username, testUser.username, @"Users are not the same after save");
}

-(void) testUserCanBeAuthenticatedAgainstCurrentUser
{
    VPNUser* testUser = [[VPNUser alloc] init];
    testUser.username = @"chris@shireman.net";
    testUser.password = @"password";
    testUser.first_name = @"Christopher";
    testUser.last_name = @"Shireman";
    
    [testUser saveAsDefaultUser];
    
    VPNUser* anotherUser = [testUser copy];
    BOOL authenticated = [anotherUser authenticate];
    STAssertTrue(authenticated, @"User copy could not be authenticated");
}

@end
