//
//  VPNListViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/14/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNCDManagerDelegate.h"
#import "VPNEditDonationListDelegate.h"
#import "VPNDonationListGroup.h"
#import "VPNUser.h"

#define kHeaderLabelTag     1
#define kAmountLabelTag     2

@interface VPNListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,VPNCDManagerDelegate, VPNEditDonationListDelegate>

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) VPNDonationListGroup* group;
@property (strong, nonatomic) VPNUser* user;

@property (assign) double total;

- (IBAction)editButtonPushed:(id)sender;
- (IBAction)addButtonPushed:(id)sender;

//VPNCDManager Delegate methods
-(void) didDeleteList:(id)list;
-(void) deleteListFailedWithError:(NSError *)error;

//VPNEditDonationList Delegate Methods
-(void) didFinishEditingDonationList:(VPNDonationList*)donationList;

@end
