//
//  VPNSelectTaxRateViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VPNSelectTaxRateViewController;
@protocol VPNSelectTaxRateViewControllerDelegate <NSObject>

-(void) selectTaxRateCanceled;
-(void) selectTaxRateSaved;

@end

@interface VPNSelectTaxRateViewController : UIViewController

@property (weak, nonatomic) id<VPNSelectTaxRateViewControllerDelegate> delegate;

-(IBAction)savePushed:(id)sender;
-(IBAction)cancelPushed:(id)sender;

@end
