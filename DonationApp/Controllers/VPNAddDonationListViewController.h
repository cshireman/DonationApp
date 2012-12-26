//
//  VPNAddDonationListViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/10/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VPNDonationList.h"
#import "VPNOrganization.h"
#import "VPNCDManager.h"
#import "VPNCDManagerDelegate.h"
#import "VPNEditDonationListDelegate.h"

@interface VPNAddDonationListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, VPNCDManagerDelegate>

@property (strong, nonatomic) id<VPNEditDonationListDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView* listTable;

@property (strong, nonatomic) IBOutlet UIView* datePickerView;
@property (strong, nonatomic) IBOutlet UIView* organizationPickerView;
@property (strong, nonatomic) IBOutlet UIView* itemSourcePickerView;

@property (strong, nonatomic) IBOutlet UIDatePicker* datePicker;
@property (strong, nonatomic) IBOutlet UIPickerView* organizationPicker;
@property (strong, nonatomic) IBOutlet UIPickerView* itemSourcePicker;

@property (strong, nonatomic) IBOutlet UIView* keyboardToolbar;
@property (strong, nonatomic) IBOutlet UIButton* startAddingItemsButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* doneButton;

@property (strong, nonatomic) IBOutlet UITextField* notesField;

@property (strong, nonatomic) VPNDonationList* donationList;
@property (strong, nonatomic) VPNOrganization* organization;

@property (assign) int selectedListType;

-(IBAction) datePickerDonePushed:(id)sender;
-(IBAction) organizationPickerDonePushed:(id)sender;
-(IBAction) itemSourcePickerDonePushed:(id)sender;

-(IBAction) keyboardDone:(id)sender;

-(IBAction) donePushed:(id)sender;
-(IBAction) startAddingItemsPushed:(id)sender;

//UITableView DataSource methods

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;

//UITableView Delegate methods
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
