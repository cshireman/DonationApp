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
@property (assign)            BOOL sessionStarted;

//Lists
@property (strong, nonatomic) NSMutableArray* itemLists;
@property (strong, nonatomic) NSMutableArray* cashLists;
@property (strong, nonatomic) NSMutableArray* mileageLists;
@property (strong, nonatomic) NSMutableDictionary* categoryList;

//Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
