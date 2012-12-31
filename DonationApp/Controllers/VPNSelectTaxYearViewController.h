//
//  VPNSelectTaxYearViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 11/15/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNCDManager.h"
#import "VPNCDManagerDelegate.h"

@interface VPNSelectTaxYearViewController : UITableViewController <VPNCDManagerDelegate>

@property (assign) BOOL showPurchaseButton;

@property (strong, nonatomic) IBOutlet UIView* purchaseView;

-(void) setCanPurchase:(NSNumber*)canPurchase;

-(void) setInstallLabel:(NSNotification*)notification;
-(void) updateInstallLabel:(NSNotification*)notification;

-(IBAction) buyNowPushed:(UIButton*)sender;

//GetItemLists
-(void) didGetItemLists:(NSArray*)itemLists;
-(void) getItemListsFailedWithError:(NSError*)error;

//GetCashLists
-(void) didGetCashLists:(NSArray*)cashLists;
-(void) getCashListsFailedWithError:(NSError*)error;

//GetMileageLists
-(void) didGetMileageLists:(NSArray*)mileageLists;
-(void) getMileageListsFailedWithError:(NSError*)error;

//GetCategoryList
-(void) didGetCategoryList:(NSArray*)categoryList;
-(void) getCategoryListFailedWithError:(NSError*)error;

@end
