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
#import "VPNCDManager.h"

@interface VPNDonationItemListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,VPNEditDonationListDelegate,VPNCDManagerDelegate>

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

//VPNCDManagerDelegate Methods
-(void)didDeleteListItem:(id)item;
-(void)deleteListItemFailedWithError:(NSError *)error;


@end
