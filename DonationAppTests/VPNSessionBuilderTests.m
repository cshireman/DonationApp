//
//  VPNSessionBuilderTests.m
//  DonationApp
//
//  Created by Chris Shireman on 10/31/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSessionBuilderTests.h"

@implementation VPNSessionBuilderTests

-(void) setUp
{
    sessionBuilder = [[VPNSessionBuilder alloc] init];
}

-(void) tearDown
{
    sessionBuilder = nil;
}

-(void) testSessionBuilderCanBeCreated
{
    STAssertNotNil(sessionBuilder,@"Session builder should have been created");
}

-(void) testThatNilIsNotAnAcceptableParameter
{
    STAssertThrows([sessionBuilder sessionFromJSON:nil error:NULL], @"Lack of data should have been handled somewhere else");
}

-(void) testThatNilReturnedWhenStringIsNotJSON
{
    STAssertNil([sessionBuilder sessionFromJSON:@"Not JSON" error:NULL], @"Invalid JSON should reutrn nil");
}

-(void) testErrorSetWhenStringIsNotJSON
{
    NSError* error = nil;
    [sessionBuilder sessionFromJSON:@"Not JSON" error:&error];
    STAssertNotNil(error,@"Error should be set when string is not JSON");
}

-(void) testPassingNullErrorDoesNotCauseCrash
{
    STAssertNoThrow([sessionBuilder sessionFromJSON:@"Not JSON" error:NULL], @"NULL error should not be a problem");
}

-(void) testRealJSONWithoutSessionInfoReturnsMissingDataError
{
    NSString* jsonString = @"{\"notsession\":true}";
    NSError* error = nil;
    [sessionBuilder sessionFromJSON:jsonString error:&error];
    
    STAssertEquals([error code], VPNSessionBuilderMissingDataError,@"No user should mean a missing data error");
}

-(void) testRealJSONWithSessionInfoReturnsSession
{
    NSString* jsonString = @"{\"d\":{\"session\":\"1234\"}}";
    VPNSession* session = [sessionBuilder sessionFromJSON:jsonString error:NULL];
    
    STAssertEqualObjects(@"1234", session.session, @"SessionID should have been set");
}



@end
