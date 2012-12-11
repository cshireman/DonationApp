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

@interface VPNAddDonationListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView* listTable;
@property (strong, nonatomic) IBOutlet UISegmentedControl* listTypeSelector;

@property (strong, nonatomic) IBOutlet UIView* datePickerView;
@property (strong, nonatomic) IBOutlet UIView* organizationPickerView;
@property (strong, nonatomic) IBOutlet UIView* itemSourcePickerView;

@property (strong, nonatomic) IBOutlet UIDatePicker* datePicker;
@property (strong, nonatomic) IBOutlet UIPickerView* organizationPicker;
@property (strong, nonatomic) IBOutlet UIPickerView* itemSourcePicker;

@property (strong, nonatomic) VPNDonationList* donationList;
@property (strong, nonatomic) VPNOrganization* organization;

-(IBAction) datePickerDonePushed:(id)sender;
-(IBAction) organizationPickerDonePushed:(id)sender;
-(IBAction) itemSourcePickerDonePushed:(id)sender;

//UITableView DataSource methods

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;

//UITableView Delegate methods
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
