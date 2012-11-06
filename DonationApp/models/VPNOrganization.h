//
//  VPNOrganization.h
//  DonationApp
//
//  Created by Chris Shireman on 11/5/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPNOrganization : NSObject

@property (assign) int ID;
@property (assign) BOOL is_active;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* address;

@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* state;
@property (nonatomic, copy) NSString* zip_code;

@property (assign) int list_count;

@end
