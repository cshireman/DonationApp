//
//  VPNPurchaseTaxYearViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNCDManagerDelegate.h"

@interface VPNPurchaseTaxYearViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,VPNCDManagerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *applyPromoCodeButton;
@property (strong, nonatomic) IBOutlet UITextField *promoCodeField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *buyNowButton;

- (IBAction)applyPromoCodePushed:(id)sender;
- (IBAction)buyNowPushed:(id)sender;

@end
