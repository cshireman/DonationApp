//
//  VPNOrganization.m
//  DonationApp
//
//  Created by Chris Shireman on 11/5/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNOrganization.h"

@implementation VPNOrganization
@synthesize ID;
@synthesize is_active;
@synthesize name;
@synthesize address;
@synthesize city;
@synthesize state;
@synthesize zip_code;
@synthesize list_count;

#pragma mark -
#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:ID forKey:kOrganizationIDKey];
    [coder encodeBool:is_active forKey:kOrganizationIsActiveKey];
    [coder encodeObject:name forKey:kOrganizationNameKey];
    [coder encodeObject:address forKey:kOrganizationAddressKey];
    [coder encodeObject:city forKey:kOrganizationCityKey];

    [coder encodeObject:state forKey:kOrganizationStateKey];
    [coder encodeObject:zip_code forKey:kOrganizationZipCodeKey];
    [coder encodeInt:list_count forKey:kOrganizationListCountKey];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        ID = [coder decodeIntForKey:kOrganizationIDKey];
        is_active = [coder decodeBoolForKey:kOrganizationIsActiveKey];
        name = [coder decodeObjectForKey:kOrganizationNameKey];
        address = [coder decodeObjectForKey:kOrganizationAddressKey];
        city = [coder decodeObjectForKey:kOrganizationCityKey];

        state = [coder decodeObjectForKey:kOrganizationStateKey];
        zip_code = [coder decodeObjectForKey:kOrganizationZipCodeKey];
        list_count = [coder decodeIntForKey:kOrganizationListCountKey];
    }
    
    return self;
}

#pragma mark -
#pragma mark Custom Methods

-(id) initWithDictionary:(NSDictionary*)info
{
    self = [super init];
    if(self)
    {
        self.ID = [[info objectForKey:@"ID"] intValue];
        self.is_active = [[info objectForKey:@"IsActive"] boolValue];
        self.name = [info objectForKey:@"Name"];
        self.address = [info objectForKey:@"Address1"];
        
        if(![[info objectForKey:@"Address2"] isEqualToString:@""])
        {
            self.address = [NSString stringWithFormat:@"%@ %@",self.address,[info objectForKey:@"Address2"]];
        }
        
        self.city = [info objectForKey:@"City"];
        self.state = [info objectForKey:@"State"];
        self.zip_code = [info objectForKey:@"Zip"];
        self.list_count = [[info objectForKey:@"ListCount"] intValue];
    }
    
    return self;
}

+(NSMutableArray*) loadOrganizationsFromDisc
{
    [VPNNotifier postNotification:@"LoadingOrganizationsFromDisc"];
    NSData* data = [[NSMutableData alloc] initWithContentsOfFile:[VPNOrganization organizationFilePath]];
    if(nil == data)
        return nil;
    
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray* organizations = (NSMutableArray*)[unarchiver decodeObjectForKey:@"Organizations"];
    [unarchiver finishDecoding];
    
    return organizations;
}

+(void) saveOrganizationsToDisc:(NSArray*)organizations
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:organizations forKey:@"Organizations"];
    [archiver finishEncoding];
    
    [data writeToFile:[VPNOrganization organizationFilePath] atomically:YES];
}

+(NSString*) organizationFilePath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kOrganizationsFilePath];
}

@end
