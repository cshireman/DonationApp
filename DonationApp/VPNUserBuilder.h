//
//  VPNUserBuilder.h
//  DonationApp
//
//  Created by Chris Shireman on 10/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNUser.h"

extern NSString* VPNUserBuilderError;

enum {
    VPNUserBuilderInvalidJSONError,
    VPNUserBuilderMissingDataError
};


@interface VPNUserBuilder : NSObject

-(VPNUser*)userFromJSON:(NSString*)objectNotation error:(NSError**)error;

@end
