//
//  VPNPurchaseTaxYearViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <MessageUI/MessageUI.h>
#import "VPNCDManagerDelegate.h"
#import "GradientButton.h"

@interface VPNPurchaseTaxYearViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,VPNCDManagerDelegate,UIAlertViewDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet GradientButton *applyPromoCodeButton;
@property (strong, nonatomic) IBOutlet UITextField *promoCodeField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet GradientButton *buyNowButton;

- (IBAction)applyPromoCodePushed:(id)sender;
- (IBAction)buyNowPushed:(id)sender;

@end
