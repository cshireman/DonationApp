//
//  VPNMileageList.m
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNMileageList.h"
#import "NSDate+CDParser.h"

@implementation VPNMileageList
@synthesize ID;
@synthesize listType;
@synthesize companyID;
@synthesize creationDate;
@synthesize donationDate;
@synthesize name;
@synthesize mileage;
@synthesize notes;


#pragma mark -
#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:ID forKey:kMileageListsIDKey];
    [coder encodeInt:listType forKey:kMileageListsListTypeKey];
    [coder encodeInt:companyID forKey:kMileageListsCompanyIDKey];
    
    [coder encodeObject:creationDate forKey:kMileageListsCreationDateKey];
    [coder encodeObject:donationDate forKey:kMileageListsDonationDateKey];
    
    [coder encodeObject:name forKey:kMileageListsNameKey];
    
    [coder encodeObject:mileage forKey:kMileageListsMileageKey];
    [coder encodeObject:notes forKey:kMileageListsNotesKey];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        ID = [coder decodeIntForKey:kMileageListsIDKey];
        listType = [coder decodeIntForKey:kMileageListsListTypeKey];
        companyID = [coder decodeIntForKey:kMileageListsCompanyIDKey];
        
        creationDate = [coder decodeObjectForKey:kMileageListsCreationDateKey];
        donationDate = [coder decodeObjectForKey:kMileageListsDonationDateKey];
        
        name = [coder decodeObjectForKey:kMileageListsNameKey];
        mileage = [coder decodeObjectForKey:kMileageListsMileageKey];
        notes = [coder decodeObjectForKey:kMileageListsNotesKey];
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
        self.listType = [[info objectForKey:@"ListType"] intValue];
        self.companyID = [[info objectForKey:@"CompanyID"] intValue];
        
        self.creationDate = [NSDate dateWithCDValue:[info objectForKey:@"CreationDate"]];
        self.donationDate = [NSDate dateWithCDValue:[info objectForKey:@"DonationDate"]];
        
        self.name = [info objectForKey:@"Name"];
        self.mileage = [info objectForKey:@"Mileage"];
        self.notes = [info objectForKey:@"Notes"];
    }
    
    return self;
}

+(NSMutableArray*) loadMileageListsFromDisc:(int)taxYear
{
    [VPNNotifier postNotification:@"LoadingMileageListsFromDisc"];
    NSData* data = [[NSMutableData alloc] initWithContentsOfFile:[VPNMileageList mileageListsFilePath:taxYear]];
    if(nil == data)
        return nil;
    
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray* organizations = (NSMutableArray*)[unarchiver decodeObjectForKey:@"MileageLists"];
    [unarchiver finishDecoding];
    
    return organizations;
}

+(void) saveMileageListsToDisc:(NSArray*)organizations forTaxYear:(int)taxYear
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:organizations forKey:@"MileageLists"];
    [archiver finishEncoding];
    
    [data writeToFile:[VPNMileageList mileageListsFilePath:taxYear] atomically:YES];
}

+(NSString*) mileageListsFilePath:(int)taxYear
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%@_%d",kMileageListsFilePath,taxYear];
    
    return [documentsDirectory stringByAppendingPathComponent:filePath];
}

@end
