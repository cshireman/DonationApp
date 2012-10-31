//
//  VPNUserBuilderTests.m
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNUserBuilderTests.h"

@implementation VPNUserBuilderTests

-(void)setUp{
    userBuilder = [[VPNUserBuilder alloc] init];
}

-(void) tearDown
{
    userBuilder = nil;
}

-(void) testThatNilIsNotAnAcceptableParameter
{
    STAssertThrows([userBuilder userFromJSON:nil error:NULL], @"Lack of data should have been handled somewhere else");
}

-(void) testThatNilReturnedWhenStringIsNotJSON
{
    STAssertNil([userBuilder userFromJSON:@"Not JSON" error:NULL], @"Invalid JSON should reutrn nil");
}

-(void) testErrorSetWhenStringIsNotJSON
{
    NSError* error = nil;
    [userBuilder userFromJSON:@"Not JSON" error:&error];
    STAssertNotNil(error,@"Error should be set when string is not JSON");
}

-(void) testPassingNullErrorDoesNotCauseCrash
{
    STAssertNoThrow([userBuilder userFromJSON:@"Not JSON" error:NULL], @"NULL error should not be a problem");
}

-(void) testRealJSONWithoutUserInfoReturnsMissingDataError
{
    NSString* jsonString = @"{\"notuser\":true}";
    NSError* error = nil;
    [userBuilder userFromJSON:jsonString error:&error];
    
//    STAssertEquals([error code], VPNUserBuilderMissingDataError,@"No user should mean a missing data error");
}



@end
