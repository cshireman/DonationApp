//
//  VPNUser.m
//  DonationApp
//
//  Created by Chris Shireman on 10/16/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNUser.h"
#import "VPNNotifier.h"
#import "VPNAppDelegate.h"


@implementation VPNUser

@synthesize username;
@synthesize password;
@synthesize first_name;
@synthesize last_name;
@synthesize phone;
@synthesize email;
@synthesize company;
@synthesize address1;
@synthesize address2;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize tax_years;
@synthesize available_tax_years;
@synthesize is_email_opted_in;
@synthesize is_trial;
@synthesize selected_tax_year;
@synthesize single_rate;
@synthesize discount_rate;


#pragma mark -
#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.username forKey:kUsernameKey];
    [coder encodeObject:self.password forKey:kPasswordKey];
    [coder encodeObject:self.first_name forKey:kFirstNameKey];
    [coder encodeObject:self.last_name forKey:kLastNameKey];
    [coder encodeObject:self.phone forKey:kPhoneKey];
    [coder encodeObject:self.company forKey:kCompanyKey];
    [coder encodeObject:self.email forKey:kEmailKey];
    [coder encodeObject:self.address1 forKey:kAddress1Key];
    [coder encodeObject:self.address2 forKey:kAddress2Key];
    [coder encodeObject:self.city forKey:kCityKey];
    [coder encodeObject:self.state forKey:kStateKey];
    [coder encodeObject:self.zip forKey:kZipKey];
    
    [coder encodeBool:self.is_email_opted_in forKey:kIsEmailOptedInKey];
    [coder encodeBool:self.is_trial forKey:kIsTrialKey];
    [coder encodeObject:self.tax_years forKey:kTaxYearsKey];
    [coder encodeObject:self.available_tax_years forKey:kAvailableTaxYearsKey];
    [coder encodeInt:self.selected_tax_year forKey:kSelectedTaxYearKey];
    [coder encodeDouble:self.single_rate forKey:kSingleRateKey];
    [coder encodeDouble:self.discount_rate forKey:kDiscountRateKey];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        username = [coder decodeObjectForKey:kUsernameKey];
        password = [coder decodeObjectForKey:kPasswordKey];
        first_name = [coder decodeObjectForKey:kFirstNameKey];
        last_name = [coder decodeObjectForKey:kLastNameKey];
        phone = [coder decodeObjectForKey:kPhoneKey];
        
        company = [coder decodeObjectForKey:kCompanyKey];
        email = [coder decodeObjectForKey:kEmailKey];
        address1 = [coder decodeObjectForKey:kAddress1Key];
        address2 = [coder decodeObjectForKey:kAddress2Key];
        city = [coder decodeObjectForKey:kCityKey];
        
        state = [coder decodeObjectForKey:kStateKey];
        zip = [coder decodeObjectForKey:kZipKey];
        
        is_email_opted_in = [coder decodeBoolForKey:kIsEmailOptedInKey];
        is_trial = [coder decodeBoolForKey:kIsTrialKey];
        tax_years = [coder decodeObjectForKey:kTaxYearsKey];
        available_tax_years = [coder decodeObjectForKey:kAvailableTaxYearsKey];
        selected_tax_year = [coder decodeIntForKey:kSelectedTaxYearKey];
        
        single_rate = [coder decodeDoubleForKey:kSingleRateKey];
        discount_rate = [coder decodeDoubleForKey:kDiscountRateKey];
    }
    
    return self;
}

-(id)copyWithZone:(NSZone*)zone
{
    VPNUser* copy = [[[self class] allocWithZone:zone] init];
    
    copy.username = self.username;
    copy.password = self.password;
    copy.first_name = self.first_name;
    copy.last_name = self.last_name;
    copy.phone = self.phone;
    
    copy.company = self.company;
    copy.address1 = self.address1;
    copy.address2 = self.address2;
    copy.city = self.city;
    copy.state = self.state;
    
    copy.zip = self.zip;
    copy.is_email_opted_in = self.is_email_opted_in;
    copy.is_trial = self.is_trial;
    
    copy.tax_years = [self.tax_years copyWithZone:zone];
    copy.available_tax_years = [self.available_tax_years copyWithZone:zone];
    copy.selected_tax_year = self.selected_tax_year;
    copy.single_rate = self.single_rate;
    copy.discount_rate = self.discount_rate;
    
    return copy;
}

-(id) initWithDictionary:(NSDictionary*)info
{
    NSParameterAssert(info != nil);
    
    self = [super init];
    if(self)
    {
        [self populateWithDictionary:info];
    }
    
    return self;
}

-(void) populateWithDictionary:(NSDictionary*)info
{
    self.first_name = [info objectForKey:@"FirstName"];
    self.last_name = [info objectForKey:@"LastName"];
    self.phone = [info objectForKey:@"Phone"];
    self.company = [info objectForKey:@"Company"];
    self.email = [info objectForKey:@"Email"];
    
    self.address1 = [info objectForKey:@"Address1"];
    self.address2 = [info objectForKey:@"Address2"];
    self.city = [info objectForKey:@"City"];
    self.state = [info objectForKey:@"State"];
    self.zip = [info objectForKey:@"Zip"];
    
    self.is_email_opted_in = ![[info objectForKey:@"EmailOptOut"] boolValue];
}

/**
 Fill any nill attributes with blank strings if they are set to nil
 */
-(void) fillWithBlanks
{
    if(first_name == nil)
        first_name = @"";
    
    if(last_name == nil)
        last_name = @"";

    if(phone == nil)
        phone = @"";

    if(company == nil)
        company = @"";

    if(email == nil)
        email = @"";

    if(address1 == nil)
        address1 = @"";

    if(address2 == nil)
        address2 = @"";

    if(city == nil)
        city = @"";

    if(state == nil)
        state = @"";

    if(zip == nil)
        zip = @"";
}

/**
 * Get the current user from memory
 */
+(VPNUser*) currentUser
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    return appDelegate.user;
}

/**
 * Load the user from the user defaults.  Set the user as the current user and returns a reference
 * to that user
 * @return VPNUser* Pointer to the VPNUser object that was loaded from the defaults
 */
+(VPNUser*) loadUserFromDisc
{
    [VPNNotifier postNotification:@"LoadingUserFromDisc"];
    NSData* data = [[NSMutableData alloc] initWithContentsOfFile:[VPNUser userFilePath]];
    if(nil == data)
    {
        return nil;
    }
    
    VPNUser* user = nil;
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    user = (VPNUser*)[unarchiver decodeObjectForKey:@"User"];
    [unarchiver finishDecoding];
    
    return user;
}

+(void) saveUserToDisc:(VPNUser*)user
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:user forKey:@"User"];
    [archiver finishEncoding];
    
    [data writeToFile:[VPNUser userFilePath] atomically:YES];    
}

+(NSString*) userFilePath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kUserFilename];
}

/**
 * Delete the user file from the disc
 */
+(void) deleteUserFromDisc
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];

    NSError* error;
    NSString* filePath = [VPNUser userFilePath];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    if([fileMgr fileExistsAtPath:filePath])
        [fileMgr removeItemAtPath:filePath error:&error];
    
    appDelegate.user = nil;
}

/**
 * Save this user to the user defaults
 */
-(void) saveAsDefaultUser
{
    VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.user = self;
}

/**
 * Authenticate this user against the API.
 * @return BOOL YES on success, NO on failure
 */
-(BOOL) authenticate
{
    VPNUser* currentUser = [VPNUser loadUserFromDisc];
    if(currentUser == nil)
        return NO;
    
    if([currentUser.username isEqualToString:self.username] &&
       [currentUser.password isEqualToString:self.password])
        return YES;
    
    return NO;
}



@end
