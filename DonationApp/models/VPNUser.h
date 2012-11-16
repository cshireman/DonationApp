//
//  VPNUser.h
//  DonationApp
//
//  Created by Chris Shireman on 10/16/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUsernameKey        @"username"
#define kPasswordKey        @"password"
#define kFirstNameKey       @"first_name"
#define kLastNameKey        @"last_name"
#define kEmailKey           @"email"
#define kIsEmailOptedInKey  @"is_email_opted_in"
#define kTaxYearsKey        @"tax_years"
#define kSelectedTaxYearKey @"selected_tax_year"

#define kUserFilename       @"user_file"

@interface VPNUser : NSObject <NSCoding, NSCopying>

@property (copy, nonatomic) NSString* username;
@property (copy, nonatomic) NSString* password;
@property (copy, nonatomic) NSString* first_name;
@property (copy, nonatomic) NSString* last_name;
@property (copy, nonatomic) NSString* email;
@property (assign) BOOL is_email_opted_in;

@property (strong, nonatomic) NSMutableArray* tax_years;
@property (assign)            int selected_tax_year;

+(VPNUser*) currentUser;
+(VPNUser*) loadUserFromDisc;
+(void) saveUserToDisc:(VPNUser*)user;
+(void) deleteUserFromDisc;
+(NSString*) userFilePath;

-(void) saveAsDefaultUser;
-(BOOL) authenticate;
-(id) initWithDictionary:(NSDictionary*)info;
-(void) populateWithDictionary:(NSDictionary*)info;


@end
