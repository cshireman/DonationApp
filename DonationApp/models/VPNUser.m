//
//  VPNUser.m
//  DonationApp
//
//  Created by Chris Shireman on 10/16/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNUser.h"

@implementation VPNUser

@synthesize username;
@synthesize password;
@synthesize first_name;
@synthesize last_name;
@synthesize email;
@synthesize tax_years;
@synthesize is_email_opted_in;

static VPNUser* currentUser = nil;

#pragma mark -
#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.username forKey:kUsernameKey];
    [coder encodeObject:self.password forKey:kPasswordKey];
    [coder encodeObject:self.first_name forKey:kFirstNameKey];
    [coder encodeObject:self.last_name forKey:kLastNameKey];
    [coder encodeObject:self.email forKey:kEmailKey];
    
    [coder encodeBool:self.is_email_opted_in forKey:kIsEmailOptedInKey];
    [coder encodeObject:self.tax_years forKey:kTaxYearsKey];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        username = [coder decodeObjectForKey:kUsernameKey];
        password = [coder decodeObjectForKey:kPasswordKey];
        first_name = [coder decodeObjectForKey:kFirstNameKey];
        last_name = [coder decodeObjectForKey:kLastNameKey];
        email = [coder decodeObjectForKey:kEmailKey];
        
        is_email_opted_in = [coder decodeBoolForKey:kIsEmailOptedInKey];
        tax_years = [coder decodeObjectForKey:kTaxYearsKey];
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
    copy.is_email_opted_in = self.is_email_opted_in;
    
    copy.tax_years = [self.tax_years copyWithZone:zone];
    
    return copy;
}

/**
 * Get the current user from memory
 */
+(VPNUser*) currentUser
{
    return currentUser;
}

/**
 * Load the user from the user defaults.  Set the user as the current user and returns a reference
 * to that user
 * @return VPNUser* Pointer to the VPNUser object that was loaded from the defaults
 */
+(VPNUser*) loadUserFromDisc
{
    NSData* data = [[NSMutableData alloc] initWithContentsOfFile:[VPNUser userFilePath]];
    if(nil == data)
        return nil;
    
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    currentUser = (VPNUser*)[unarchiver decodeObjectForKey:@"User"];
    [unarchiver finishDecoding];
    
    return [VPNUser currentUser];
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
    NSError* error;
    NSString* filePath = [VPNUser userFilePath];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    if([fileMgr fileExistsAtPath:filePath])
        [fileMgr removeItemAtPath:filePath error:&error];
}

/**
 * Save this user to the user defaults
 */
-(void) saveAsDefaultUser
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self forKey:@"User"];
    [archiver finishEncoding];
    
    [data writeToFile:[VPNUser userFilePath] atomically:YES];
    currentUser = self;
}

/**
 * Authenticate this user against the API.
 * @return BOOL YES on success, NO on failure
 */
-(BOOL) authenticate
{
    currentUser = [VPNUser loadUserFromDisc];
    if(currentUser == nil)
        return NO;
    
    if([currentUser.username isEqualToString:self.username] &&
       [currentUser.password isEqualToString:self.password])
        return YES;
    
    return NO;
}



@end
