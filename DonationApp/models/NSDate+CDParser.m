//
//  NSDate+CDParser.m
//  DonationApp
//
//  Created by Chris Shireman on 12/8/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "NSDate+CDParser.h"

@implementation NSDate (CDParser)

+(NSDate*) dateWithCDValue:(NSString*)cdValue
{
    cdValue = [cdValue stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    cdValue = [cdValue stringByReplacingOccurrencesOfString:@")/" withString:@""];
    
    NSTimeInterval cdInterval = ([cdValue longLongValue] / 1000);
    
    return [NSDate dateWithTimeIntervalSince1970:cdInterval];
}


@end
