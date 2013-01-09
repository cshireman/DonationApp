//
//  VPNDonationReportsViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNDonationReportsDelegate.h"

@interface VPNDonationReportsViewController : UITableViewController

@property (strong, nonatomic) id<VPNDonationReportsDelegate> delegate;

@property (strong, nonatomic) NSMutableArray* selectedDonationLists;
@property (strong, nonatomic) NSMutableArray* donationLists;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIView* gradientView;
- (IBAction)donePushed:(id)sender;

@end
