//
//  VPNCategoryList.h
//  DonationApp
//
//  Created by Chris Shireman on 11/27/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPNCategoryList : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray* categories;

-(id) initWithDictionary:(NSDictionary*)info;

@end
