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
@property (assign) int categoryID;
@property (assign) BOOL isCustom;

@property (strong, nonatomic) NSMutableArray* conditions;

@property (copy, nonatomic) NSString* categoryName;
@property (copy, nonatomic) NSString* itemName;
@property (strong, nonatomic) UIImage* image;

+(NSArray*) groupsFromItemsInDonationList:(VPNDonationList*)donationList;

-(NSDictionary*) buildItemSummary;
-(NSString*) imageFilename;

-(int) quantityForCondition:(ItemCondition)condition;
-(double) valueForCondition:(ItemCondition)condition;

-(void) setQuantity:(int)quantity forCondition:(ItemCondition)condition;
-(void) setValue:(double)value forCondition:(ItemCondition)condition;

-(int) totalQuantityForAllConditons;
-(double) totalValueForAllConditions;

-(void)saveImageToDisc:(UIImage*)image;
-(UIImage*)loadImageFromDisc;

@end
