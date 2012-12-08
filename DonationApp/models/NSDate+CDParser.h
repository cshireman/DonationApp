//
//  NSDate+CDParser.h
//  DonationApp
//
//  Created by Chris Shireman on 12/8/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CDParser)

+(NSDate*) dateWithCDValue:(NSString*)cdValue;

@end
