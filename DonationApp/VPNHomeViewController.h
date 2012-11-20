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
#import "VPNCDManager.h"
#import "VPNSession.h"
#import "VPNUser.h"
#import "VPNTaxSavings.h"

#define kTaxSavingsKey      @"tax_savings"
#define kItemSubtotalKey    @"items_subtotal"
#define kMoneySubtotalKey   @"money_subtotal"
#define kMileageSubtotalKey @"mileage_subtotal"

@interface VPNHomeViewController : UITableViewController <ADBannerViewDelegate, VPNSelectTaxRateViewControllerDelegate, VPNCDManagerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem* updateButton;
@property (strong, nonatomic) IBOutlet UIView* optOutView;
@property (strong, nonatomic) IBOutlet UISwitch* optOutSwitch;
@property (strong, nonatomic) IBOutlet ADBannerView* bannerView;

@property (strong, nonatomic) UITextField* nameField;
@property (strong, nonatomic) UITextField* emailField;
@property (strong, nonatomic) UITextField* passwordField;
@property (strong, nonatomic) UITextField* confirmPasswordField;

@property (strong, nonatomic) UILabel* taxSavingsLabel;

@property (strong, nonatomic) VPNSession* session;
@property (strong, nonatomic) VPNUser* user;

@property (strong, nonatomic) VPNCDManager* manager;

-(IBAction)logoutPushed:(id)sender;
-(IBAction)updatePushed:(id)sender;

//VPNSelectTaxRateViewControllerDelegate Methods
-(void) selectTaxRateCanceled;
-(void) selectTaxRateSaved;

//VPNCDManagerDelegate Methods

-(void) didChangePassword;
-(void) changePasswordFailedWithError:(NSError*)error;

-(void) didUpdateUserInfo;
-(void) updateUserInfoFailedWithError:(NSError*)error;

-(void) didGetUser:(VPNUser*)user;
-(void) getUserInfoFailedWithError:(NSError*)error;


//Custom Methods

@end
