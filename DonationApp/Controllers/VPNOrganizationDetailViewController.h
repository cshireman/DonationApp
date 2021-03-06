//
//  VPNOrganizationDetailViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 11/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNOrganization.h"
#import "VPNCDManager.h"
#import "VPNCDManagerDelegate.h"
#import "VPNNotifier.h"
#import "GradientButton.h"

@interface VPNOrganizationDetailViewController : UIViewController <VPNCDManagerDelegate,UITextFieldDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *addressField;
@property (strong, nonatomic) IBOutlet UITextField *cityField;
@property (strong, nonatomic) IBOutlet UITextField *stateField;
@property (strong, nonatomic) IBOutlet UITextField *zipField;

@property (strong, nonatomic) IBOutlet GradientButton *deleteButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem* doneButton;

@property (strong, nonatomic) VPNOrganization* organization;

- (IBAction)deletePushed:(id)sender;
- (IBAction)donePushed:(id)sender;


@end
