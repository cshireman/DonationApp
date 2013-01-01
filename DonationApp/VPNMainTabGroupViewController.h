//
//  VPNMainTabGroupViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 10/17/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNLoginViewController.h"
#import "VPNCDManager.h"
#import "VPNCDManagerDelegate.h"

@interface VPNMainTabGroupViewController : UITabBarController <VPNLoginViewControllerDelegate,VPNCDManagerDelegate>

-(void) displayLoginScene;
-(void) displaySelectTaxYearScene;

-(void) loginControllerFinished;

-(void) configure;

@end
