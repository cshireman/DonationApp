//
//  VPNUserSignupViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 10/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNCDManagerDelegate.h"
#import "GradientButton.h"

@interface VPNUserSignupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, VPNCDManagerDelegate>

@property (nonatomic, strong) IBOutlet UITableView* taxYearTable;

@property (nonatomic, strong) IBOutlet UITextField* firstNameField;
@property (nonatomic, strong) IBOutlet UITextField* lastNameField;
@property (nonatomic, strong) IBOutlet UITextField* emailField;
@property (nonatomic, strong) IBOutlet UITextField* passwordField;
@property (nonatomic, strong) IBOutlet UITextField* confirmPasswordField;
@property (strong, nonatomic) IBOutlet GradientButton *cancelButton;
@property (strong, nonatomic) IBOutlet GradientButton *submitButton;

-(IBAction)cancelPushed:(id)sender;
-(IBAction)submitPushed:(id)sender;

@end
