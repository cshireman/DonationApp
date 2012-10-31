//
//  VPNSessionBuilder.h
//  DonationApp
//
//  Created by Chris Shireman on 10/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNSession.h"
#import "VPNSessionBuilder.h"

extern NSString* VPNSessionBuilderError;

enum {
    VPNSessionBuilderInvalidJSONError,
    VPNSessionBuilderMissingDataError
};

@interface VPNSessionBuilder : NSObject

@property (strong) VPNSessionBuilder* builder;

-(VPNSession*)sessionFromJSON:(NSString*)objectNotation error:(NSError**)error;

@end
