//
//  VPNSession.h
//  DonationApp
//
//  Created by Chris Shireman on 10/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNUser.h"

@interface VPNSession : NSObject

@property (copy) NSString* session;
@property (copy) NSString* first_name;
@property (copy) NSString* last_name;
@property (assign) NSInteger annual_limit;


-(id) initWithDictionary:(NSDictionary*)info;
-(void) setAsCurrentSession;
-(void) populateWithDictionary:(NSDictionary*)info;

+(id) currentSession;
+(void) clearCurrentSession;
+(void) setCurrentSessionWithSession:(VPNSession*) newSession;

@end
