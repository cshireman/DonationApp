//
//  VPNLoginViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 10/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VPNLoginViewController;
@protocol VPNLoginViewControllerDelegate <NSObject>

-(void) loginController:(VPNLoginViewController*)login didFinish:(BOOL)status;

@end

@interface VPNLoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) id<VPNLoginViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) IBOutlet UITextField* usernameField;
@property (strong, nonatomic) IBOutlet UITextField* passwordField;

-(IBAction) loginPushed:(id) sender;
-(IBAction) dismissKeyboard;

@end
