//
//  VPNMileageList.h
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNNotifier.h"

#define kMileageListsFilePath  @"mileageLists"

#define kMileageListsIDKey                 @"ID"
#define kMileageListsListTypeKey           @"ListType"
#define kMileageListsCompanyIDKey          @"CompanyID"
#define kMileageListsCreationDateKey       @"CreationDate"
#define kMileageListsDonationDateKey       @"DonationDate"
#define kMileageListsNameKey               @"Name"
#define kMileageListsMileageKey            @"Mileage"
#define kMileageListsNotesKey              @"Notes"

@interface VPNMileageList : NSObject <NSCoding>

@property (assign) int ID;
@property (assign) int listType;
@property (assign) int companyID;

@property (nonatomic, strong) NSDate* creationDate;
@property (nonatomic, strong) NSDate* donationDate;

@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSNumber* mileage;
@property (nonatomic, copy) NSString* notes;

+(NSMutableArray*) loadMileageListsFromDisc:(int)taxYear;
+(void) saveMileageListsToDisc:(NSArray*)organizations forTaxYear:(int)taxYear;
+(NSString*) mileageListsFilePath:(int)taxYear;

-(id) initWithDictionary:(NSDictionary*)info;

@end
