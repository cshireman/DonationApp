//
//  VPNItemGroup.h
//  DonationApp
//
//  Created by Chris Shireman on 12/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNDonationList.h"
#import "VPNItem.h"

@interface VPNItemGroup : NSObject

@property (strong, nonatomic) VPNDonationList* donationList;
@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) NSMutableDictionary* summary;

@property (assign) int itemID;
@property (assign) BOOL isCustom;
@property (strong, nonatomic) NSMutableArray* conditions;

@property (strong, nonatomic) NSString* categoryName;
@property (strong, nonatomic) NSString* itemName;
@property (strong, nonatomic) UIImage* image;

+(NSArray*) groupsFromItemsInDonationList:(VPNDonationList*)donationList;

-(NSDictionary*) buildItemSummary;
-(NSString*) imageFilename;

-(void)saveImageToDisc:(UIImage*)image;
-(UIImage*)loadImageFromDisc;

@end
