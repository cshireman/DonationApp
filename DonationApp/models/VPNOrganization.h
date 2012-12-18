//
//  VPNOrganization.h
//  DonationApp
//
//  Created by Chris Shireman on 11/5/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNNotifier.h"

#define kOrganizationsFilePath  @"organizations"

#define kOrganizationIDKey          @"ID"
#define kOrganizationIsActiveKey    @"IsActive"
#define kOrganizationNameKey        @"Name"
#define kOrganizationAddressKey     @"Address"
#define kOrganizationCityKey        @"City"
#define kOrganizationStateKey       @"State"
#define kOrganizationZipCodeKey     @"Zip"
#define kOrganizationListCountKey   @"ListCount"

@interface VPNOrganization : NSObject <NSCoding>

@property (assign) int ID;
@property (assign) BOOL is_active;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* address;

@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* state;
@property (nonatomic, copy) NSString* zip_code;

@property (assign) int list_count;

+(NSMutableArray*) loadOrganizationsFromDisc;
+(void) saveOrganizationsToDisc:(NSArray*)organizations;
+(NSString*) organizationFilePath;

+(VPNOrganization*) organizationForID:(int)organizationID;

-(id) initWithDictionary:(NSDictionary*)info;

-(void) fillWithBlanks;

@end
