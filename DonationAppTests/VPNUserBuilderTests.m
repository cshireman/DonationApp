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

@end
