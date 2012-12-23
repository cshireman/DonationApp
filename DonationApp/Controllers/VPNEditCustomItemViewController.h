//
//  VPNEditCustomItemViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/19/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNItemGroup.h"
#import "VPNCustomItemConditionCellDelegate.h"
#import "VPNCustomItemConditionCell.h"
#import "VPNModalPickerDelegate.h"
#import "VPNModalPickerView.h"
#import "VPNDoneToolbarDelegate.h"
#import "VPNDoneToolbar.h"

@interface VPNEditCustomItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,VPNCustomItemConditionCellDelegate,UITextFieldDelegate,VPNModalPickerDelegate,VPNDoneToolbarDelegate>

@property (retain, nonatomic) UINib* customItemCellNib;
@property (retain, nonatomic) UINib* doneToolbarNib;

@property (strong, nonatomic) VPNItemGroup* group;

@property (strong, nonatomic) UITextField* itemNameField;

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* doneButton;

@property (strong, nonatomic) VPNDoneToolbar* doneToolbar;

//VPNDoneToolbarDelegate methods
-(void) doneToolbarButtonPushed:(id)sender;

//UITableView DataSource methods

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;

//UITableView Delegate methods
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
