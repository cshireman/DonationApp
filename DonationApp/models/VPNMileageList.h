//
//  VPNMileageList.h
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNDonationList.h"
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

@interface VPNMileageList : VPNDonationList <NSCoding>


+(NSMutableArray*) loadMileageListsFromDisc:(int)taxYear;
+(void) saveMileageListsToDisc:(NSArray*)organizations forTaxYear:(int)taxYear;
+(NSString*) mileageListsFilePath:(int)taxYear;

-(id) initWithDictionary:(NSDictionary*)info;

@end
