//
//  VPNDontationListsViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/4/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNCDManagerDelegate.h"
#import "VPNUser.h"

@interface VPNDontationListsViewController : UITableViewController <VPNCDManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel* taxSavingsLabel;

@property (strong, nonatomic) NSMutableArray* itemLists;
@property (strong, nonatomic) NSMutableArray* cashLists;
@property (strong, nonatomic) NSMutableArray* mileageLists;

@property (strong, nonatomic) VPNUser* user;

@property (assign) double taxSavings;
@property (assign) double itemsTotal;
@property (assign) double cashTotal;
@property (assign) int mileageTotal;

- (IBAction)editButtonPushed:(id)sender;
- (IBAction)addButtonPushed:(id)sender;

//VPNCDManager Delegate methods
-(void) didDeleteList:(id)list;
-(void) deleteListFailedWithError:(NSError *)error;

@end
