//
//  VPNCashListViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/13/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNListViewController.h"
#import "GradientButton.h"

@interface VPNCashListViewController : VPNListViewController
@property (strong, nonatomic) IBOutlet GradientButton *addMoneyButton;

@end
