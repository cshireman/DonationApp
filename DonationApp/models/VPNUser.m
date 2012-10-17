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

+(VPNUser*) currentUser
{
    return currentUser;
}


@end
