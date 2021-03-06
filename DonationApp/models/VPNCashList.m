//
//  VPNCashList.m
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNCashList.h"
#import "NSDate+CDParser.h"

@implementation VPNCashList

@synthesize ID;
@synthesize listType;
@synthesize companyID;
@synthesize creationDate;
@synthesize donationDate;
@synthesize name;
@synthesize cashDonation;
@synthesize notes;

#pragma mark -
#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:ID forKey:kCashListsIDKey];
    [coder encodeInt:listType forKey:kCashListsListTypeKey];
    [coder encodeInt:companyID forKey:kCashListsCompanyIDKey];
    
    [coder encodeObject:creationDate forKey:kCashListsCreationDateKey];
    [coder encodeObject:donationDate forKey:kCashListsDonationDateKey];
    
    [coder encodeObject:name forKey:kCashListsNameKey];
    [coder encodeObject:cashDonation forKey:kCashListsCashDonationKey];
    [coder encodeObject:notes forKey:kCashListsNotesKey];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        ID = [coder decodeIntForKey:kCashListsIDKey];
        listType = [coder decodeIntForKey:kCashListsListTypeKey];
        companyID = [coder decodeIntForKey:kCashListsCompanyIDKey];
        
        creationDate = [coder decodeObjectForKey:kCashListsCreationDateKey];
        donationDate = [coder decodeObjectForKey:kCashListsDonationDateKey];
        
        name = [coder decodeObjectForKey:kCashListsNameKey];
        cashDonation = [coder decodeObjectForKey:kCashListsCashDonationKey];
        notes = [coder decodeObjectForKey:kCashListsNotesKey];
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
        self.cashDonation = [info objectForKey:@"CashDonation"];
        self.notes = [info objectForKey:@"Notes"];        
    }
    
    return self;
}

+(NSMutableArray*) loadCashListsFromDisc:(int)taxYear
{
    [VPNNotifier postNotification:@"LoadingCashListsFromDisc"];
    NSData* data = [[NSMutableData alloc] initWithContentsOfFile:[VPNCashList cashListsFilePath:taxYear]];
    if(nil == data)
        return nil;
    
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray* organizations = (NSMutableArray*)[unarchiver decodeObjectForKey:@"CashLists"];
    [unarchiver finishDecoding];
    
    return organizations;
}

+(void) saveCashListsToDisc:(NSArray*)organizations forTaxYear:(int)taxYear
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:organizations forKey:@"CashLists"];
    [archiver finishEncoding];
    
    [data writeToFile:[VPNCashList cashListsFilePath:taxYear] atomically:YES];
}

+(NSString*) cashListsFilePath:(int)taxYear
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%@_%d",kCashListsFilePath,taxYear];
    
    return [documentsDirectory stringByAppendingPathComponent:filePath];
}

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary* info = [super toDictionary];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    [info setObject:[NSNumber numberWithInt:self.companyID] forKey:@"companyID"];
    [info setObject:[formatter stringFromDate:self.creationDate] forKey:@"creationDate"];
    [info setObject:[formatter stringFromDate:self.donationDate] forKey:@"donationDate"];
    [info setObject:self.name forKey:@"name"];
    
    [info setObject:self.notes forKey:@"notes"];
    [info setObject:self.name forKey:@"name"];
    [info setObject:@"" forKey:@"dateAquired"];
    [info setObject:@"" forKey:@"howAquired"];
    
    [info setObject:@"" forKey:@"costBasis"];
    [info setObject:self.cashDonation forKey:@"cashDonation"];
    [info setObject:@"" forKey:@"miles"];
    
    return info;
}


@end
