//
//  VPNHomeViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 10/16/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface VPNHomeViewController : UITableViewController <ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem* updateButton;
@property (strong, nonatomic) IBOutlet UIView* optOutView;
@property (strong, nonatomic) IBOutlet UISwitch* optOutSwitch;
@property (strong, nonatomic) IBOutlet ADBannerView* bannerView;

-(IBAction)logoutPushed:(id)sender;
-(IBAction)updatePushed:(id)sender;

@end
