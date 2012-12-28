//
//  VPNDonationItemListViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/12/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNEditDonationListDelegate.h"
#import "VPNCDManagerDelegate.h"
#import "VPNEditDonationListDelegate.h"
#import "VPNEditCustomItemDelegate.h"
#import "VPNCDManager.h"
#import "VPNItemGroup.h"
#import "VPNItemGroupDelegate.h"

@interface VPNDonationItemListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,VPNEditDonationListDelegate,VPNEditCustomItemDelegate,VPNCDManagerDelegate,VPNItemGroupDelegate>

@property (strong, nonatomic) IBOutlet UILabel *organizationLabel;
@property (strong, nonatomic) IBOutlet UILabel *donationListInfoLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) VPNDonationList* donationList;
@property (strong, nonatomic) VPNOrganization* organization;

@property (strong, nonatomic) NSMutableArray* itemGroups;

- (IBAction)backPushed:(id)sender;
- (IBAction)editPushed:(id)sender;
- (IBAction)addCustomItemPushed:(id)sender;
- (IBAction)addItemPushed:(id)sender;
- (IBAction)editListPushed:(id)sender;


//VPNEditDonationListDelegate Methods
-(void) itemGroupAdded:(VPNItemGroup*) addedGroup;
-(void) itemGroupUpdated:(VPNItemGroup*) updatedGroup;

@end
