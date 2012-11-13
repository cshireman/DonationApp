//
//  VPNMainTabGroupViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 10/17/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNLoginViewController.h"

@interface VPNMainTabGroupViewController : UITabBarController <VPNLoginViewControllerDelegate>

-(void) displayLoginScene;
-(void) displaySelectTaxYearScene;

-(void) loginControllerFinished;

@end
