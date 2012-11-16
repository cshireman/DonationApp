//
//  VPNHomeViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 10/16/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "VPNSelectTaxRateViewController.h"
#import "VPNSession.h"
#import "VPNUser.h"

#define kTaxSavingsKey      @"tax_savings"
#define kItemSubtotalKey    @"items_subtotal"
#define kMoneySubtotalKey   @"money_subtotal"
#define kMileageSubtotalKey @"mileage_subtotal"

@interface VPNHomeViewController : UITableViewController <ADBannerViewDelegate, VPNSelectTaxRateViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem* updateButton;
@property (strong, nonatomic) IBOutlet UIView* optOutView;
@property (strong, nonatomic) IBOutlet UISwitch* optOutSwitch;
@property (strong, nonatomic) IBOutlet ADBannerView* bannerView;

@property (strong, nonatomic) VPNSession* session;
@property (strong, nonatomic) VPNUser* user;

-(IBAction)logoutPushed:(id)sender;
-(IBAction)updatePushed:(id)sender;

//VPNSelectTaxRateViewControllerDelegate Methods
-(void) selectTaxRateCanceled;
-(void) selectTaxRateSaved;

//Custom Methods


@end
