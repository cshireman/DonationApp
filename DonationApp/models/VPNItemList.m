//
//  VPNItemList.m
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNItemList.h"
#import "VPNItem.h"


@implementation VPNItemList

@synthesize ID;
@synthesize listType;
@synthesize companyID;
@synthesize creationDate;
@synthesize donationDate;
@synthesize name;
@synthesize dateAquired;
@synthesize howAquired;
@synthesize costBasis;
@synthesize notes;
@synthesize items;

#pragma mark -
#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:ID forKey:kItemListsIDKey];
    [coder encodeInt:listType forKey:kItemListsListTypeKey];
    [coder encodeInt:companyID forKey:kItemListsCompanyIDKey];
    
    [coder encodeObject:creationDate forKey:kItemListsCreationDateKey];
    [coder encodeObject:donationDate forKey:kItemListsDonationDateKey];
    
    [coder encodeObject:name forKey:kItemListsNameKey];
    [coder encodeObject:dateAquired forKey:kItemListsDateAquiredKey];
    [coder encodeObject:howAquired forKey:kItemListsHowAquiredKey];

    [coder encodeObject:costBasis forKey:kItemListsCostBasisKey];
    [coder encodeObject:notes forKey:kItemListsNotesKey];
    [coder encodeObject:items forKey:kItemListsItemsKey];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        ID = [coder decodeIntForKey:kItemListsIDKey];
        listType = [coder decodeIntForKey:kItemListsListTypeKey];
        companyID = [coder decodeIntForKey:kItemListsCompanyIDKey];
        
        creationDate = [coder decodeObjectForKey:kItemListsCreationDateKey];
        donationDate = [coder decodeObjectForKey:kItemListsDonationDateKey];
        
        name = [coder decodeObjectForKey:kItemListsNameKey];
        dateAquired = [coder decodeObjectForKey:kItemListsDateAquiredKey];
        howAquired = [coder decodeObjectForKey:kItemListsHowAquiredKey];
        
        costBasis = [coder decodeObjectForKey:kItemListsCostBasisKey];
        notes = [coder decodeObjectForKey:kItemListsNotesKey];
        items = [coder decodeObjectForKey:kItemListsItemsKey];
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
        
        self.creationDate = [NSDate dateWithTimeIntervalSince1970:[[info objectForKey:@"CreationDate"] doubleValue]];
        self.donationDate = [NSDate dateWithTimeIntervalSince1970:[[info objectForKey:@"DonationDate"] doubleValue]];
        
        self.name = [info objectForKey:@"Name"];
        self.dateAquired = [info objectForKey:@"DateAquired"];
        self.howAquired = [info objectForKey:@"HowAquired"];
        
        self.costBasis = [info objectForKey:@"CostBasis"];
        self.notes = [info objectForKey:@"Notes"];
        
        NSArray* rawItems = [info objectForKey:@"Items"];
        items = [[NSMutableArray alloc] initWithCapacity:[rawItems count]];

        for(NSDictionary* itemInfo in rawItems)
        {
            VPNItem* item = [[VPNItem alloc] initWithDictionary:itemInfo];
            [items addObject:item];
        }
    }
    
    return self;
}

+(NSMutableArray*) loadItemListsFromDisc:(int)taxYear
{
    [VPNNotifier postNotification:@"LoadingItemListsFromDisc"];
    NSData* data = [[NSMutableData alloc] initWithContentsOfFile:[VPNItemList itemListsFilePath:taxYear]];
    if(nil == data)
        return nil;
    
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray* organizations = (NSMutableArray*)[unarchiver decodeObjectForKey:@"ItemLists"];
    [unarchiver finishDecoding];
    
    return organizations;
}

+(void) saveItemListsToDisc:(NSArray*)organizations forTaxYear:(int)taxYear
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:organizations forKey:@"ItemLists"];
    [archiver finishEncoding];
    
    [data writeToFile:[VPNItemList itemListsFilePath:taxYear] atomically:YES];
}

+(NSString*) itemListsFilePath:(int)taxYear
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%@_%d",kItemListsFilePath,taxYear];
    
    return [documentsDirectory stringByAppendingPathComponent:filePath];
}

@end
