//
//  VPNSessionTests.m
//  DonationApp
//
//  Created by Chris Shireman on 10/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSessionTests.h"

@implementation VPNSessionTests

-(void) setUp
{
    session = [[VPNSession alloc] init];
}

-(void) tearDown
{
    session = nil;
    [VPNSession clearCurrentSession];
}

-(void) testSessionCanBeCreated
{
    STAssertNotNil(session,@"Session should be able to be created");
}

-(void) testSessionCanBeLoadedFromDictionary
{
    NSDictionary* testSessionInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"1234",@"session",
                                     @"Joe",@"firstName",
                                     @"Tester",@"lastName",
                                     [NSNumber numberWithInt:15000],@"annualLimit", nil];
    
    session = [[VPNSession alloc] initWithDictionary:testSessionInfo];
    STAssertEqualObjects(session.session, @"1234", @"Session should be able to loaded from dictionary");
    STAssertEqualObjects(session.first_name, @"Joe", @"Session should be able to loaded from dictionary");
    STAssertEqualObjects(session.last_name, @"Tester", @"Session should be able to loaded from dictionary");
    STAssertEquals(session.annual_limit, 15000, @"Session should be able to loaded from dictionary");
}

-(void) testCurrentSessionCanBeSet
{
    [VPNSession setCurrentSessionWithSession:session];
    STAssertNotNil([VPNSession currentSession], @"Current session should have be set");
}

@end
