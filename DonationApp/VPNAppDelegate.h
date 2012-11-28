//
//  VPNAppDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 10/15/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNTaxSavings.h"
#import "VPNSession.h"
#import "VPNUser.h"

@interface VPNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) VPNTaxSavings* taxSavings;
@property (strong, nonatomic) VPNSession* userSession;
@property (strong, nonatomic) VPNUser* user;
@property (assign)            double currentTaxSavings;

//Lists
@property (strong, nonatomic) NSMutableArray* itemLists;
@property (strong, nonatomic) NSMutableArray* cashLists;
@property (strong, nonatomic) NSMutableArray* mileageLists;
@property (strong, nonatomic) NSMutableDictionary* categoryList;

@end
