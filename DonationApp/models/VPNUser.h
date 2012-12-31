//
//  VPNUser.h
//  DonationApp
//
//  Created by Chris Shireman on 10/16/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUsernameKey            @"username"
#define kPasswordKey            @"password"
#define kFirstNameKey           @"first_name"
#define kLastNameKey            @"last_name"
#define kPhoneKey               @"phone"
#define kCompanyKey             @"company"
#define kEmailKey               @"email"
#define kAddress1Key            @"address1"
#define kAddress2Key            @"address2"
#define kCityKey                @"city"
#define kStateKey               @"state"
#define kZipKey                 @"zip"
#define kIsEmailOptedInKey      @"is_email_opted_in"
#define kIsTrialKey             @"is_trial"
#define kTaxYearsKey            @"tax_years"
#define kAvailableTaxYearsKey   @"available_tax_years"
#define kSelectedTaxYearKey     @"selected_tax_year"
#define kSingleRateKey          @"single_rate"
#define kDiscountRateKey        @"discount_rate"

#define kUserFilename           @"user_file"

@interface VPNUser : NSObject <NSCoding, NSCopying>

@property (copy, nonatomic) NSString* username;
@property (copy, nonatomic) NSString* password;
@property (copy, nonatomic) NSString* first_name;
@property (copy, nonatomic) NSString* last_name;
@property (copy, nonatomic) NSString* phone;
@property (copy, nonatomic) NSString* company;
@property (copy, nonatomic) NSString* email;
@property (copy, nonatomic) NSString* address1;
@property (copy, nonatomic) NSString* address2;
@property (copy, nonatomic) NSString* city;
@property (copy, nonatomic) NSString* state;
@property (copy, nonatomic) NSString* zip;

@property (assign) BOOL is_email_opted_in;
@property (assign) BOOL is_trial;

@property (strong, nonatomic) NSMutableArray* tax_years;
@property (strong, nonatomic) NSMutableArray* available_tax_years;

@property (assign) int selected_tax_year;
@property (assign) double single_rate;
@property (assign) double discount_rate;


+(VPNUser*) currentUser;
+(VPNUser*) loadUserFromDisc;
+(void) saveUserToDisc:(VPNUser*)user;
+(void) deleteUserFromDisc;
+(NSString*) userFilePath;

-(void) saveAsDefaultUser;
-(BOOL) authenticate;
-(id) initWithDictionary:(NSDictionary*)info;
-(void) populateWithDictionary:(NSDictionary*)info;
-(void) fillWithBlanks;


@end
