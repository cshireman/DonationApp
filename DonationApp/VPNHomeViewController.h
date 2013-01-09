//
//  VPNHomeViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 10/16/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "VPNSelectTaxRateViewController.h"
#import "VPNCDManager.h"
#import "VPNSession.h"
#import "VPNUser.h"
#import "VPNTaxSavings.h"
#import "VPNDoneToolbar.h"
#import "VPNDoneToolbarDelegate.h"
#import "VPNPasswordCell.h"
#import "VPNContactInfoCell.h"

#define kTaxSavingsKey      @"tax_savings"
#define kItemSubtotalKey    @"items_subtotal"
#define kMoneySubtotalKey   @"money_subtotal"
#define kMileageSubtotalKey @"mileage_subtotal"

@interface VPNHomeViewController : UITableViewController <ADBannerViewDelegate, VPNSelectTaxRateViewControllerDelegate, VPNCDManagerDelegate,VPNDoneToolbarDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,VPNPasswordCellDelegate,VPNContactInfoCellDelegate>

@property (retain, nonatomic) UINib* passwordCellNib;
@property (retain, nonatomic) UINib* contactInfoCellNib;
@property (retain, nonatomic) UINib* doneToolbarNib;
@property (strong, nonatomic) VPNDoneToolbar* doneToolbar;

@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSString* confirmPassword;

@property (strong, nonatomic) IBOutlet UIBarButtonItem* updateButton;
@property (strong, nonatomic) IBOutlet UIView* optOutView;
@property (strong, nonatomic) IBOutlet UISwitch* optOutSwitch;
@property (strong, nonatomic) IBOutlet ADBannerView* bannerView;

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
