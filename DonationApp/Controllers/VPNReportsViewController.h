//
//  VPNReportsViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNCDManager.h"
#import "VPNCDManagerDelegate.h"
#import "VPNDonationReportsDelegate.h"
#import "GradientButton.h"

@interface VPNReportsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,VPNCDManagerDelegate,VPNDonationReportsDelegate>

@property (assign) BOOL sendItemizedReport;
@property (assign) BOOL sendTaxSummaryReport;

@property (strong, nonatomic) NSMutableArray* donationLists;

@property (strong, nonatomic) IBOutlet UIView* tableHeader;

@property (strong, nonatomic) IBOutlet UILabel *taxYearLabel;
@property (strong, nonatomic) IBOutlet GradientButton *emailReportsButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)taxYearButtonPushed:(id)sender;
- (IBAction)emailReportsPushed:(id)sender;

@end
