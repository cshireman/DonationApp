//
//  VPNOrganizationListViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 11/5/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNOrganization.h"
#import "VPNCDManager.h"

@interface VPNOrganizationListViewController : UITableViewController <VPNCDManagerDelegate>

@property (nonatomic, strong) NSMutableArray* organizations;
@property (nonatomic, strong) VPNCDManager* manager;

-(IBAction) editPushed;

@end
