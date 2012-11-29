//
//  VPNCategoryList.m
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNCategoryList.h"
#import "VPNNotifier.h"

@implementation VPNCategoryList
@synthesize categories;

#pragma mark -
#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:categories forKey:@"categories"];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        categories = [coder decodeObjectForKey:@"categories"];
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
        NSArray* rawCategories = [info objectForKey:@"categories"];
        categories = [[NSMutableArray alloc] initWithCapacity:[rawCategories count]];
        
//        for(NSDictionary* categoryInfo in rawCategories)
//        {
//            VPNCategory* category = [[VPNCategory alloc] initWithDictionary:categoryInfo];
//            [categories addObject:category];
//        }
    }
    
    return self;
}


@end
