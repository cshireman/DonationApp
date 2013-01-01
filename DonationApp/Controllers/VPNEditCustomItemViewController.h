//
//  VPNEditCustomItemViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/19/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "VPNItemGroup.h"
#import "VPNItemGroupDelegate.h"
#import "VPNCustomItemConditionCellDelegate.h"
#import "VPNCustomItemConditionCell.h"
#import "VPNItemNameCellDelegate.h"
#import "VPNItemNameCell.h"
#import "VPNModalPickerDelegate.h"
#import "VPNModalPickerView.h"
#import "VPNDoneToolbarDelegate.h"
#import "VPNDoneToolbar.h"
#import "VPNEditCustomItemDelegate.h"
#import "VPNViewPhotoDelegate.h"
#import "GradientButton.h"

@interface VPNEditCustomItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,VPNCustomItemConditionCellDelegate,UITextFieldDelegate,VPNModalPickerDelegate,VPNDoneToolbarDelegate,VPNItemNameCellDelegate,VPNItemGroupDelegate,VPNCDManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,VPNViewPhotoDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) id<VPNEditCustomItemDelegate> delegate;

@property (retain, nonatomic) UINib* customItemCellNib;
@property (retain, nonatomic) UINib* itemNameCellNib;
@property (retain, nonatomic) UINib* doneToolbarNib;

@property (strong, nonatomic) VPNItemGroup* group;

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* doneButton;

@property (strong, nonatomic) VPNDoneToolbar* doneToolbar;

-(IBAction) doneButtonPushed:(id)sender;

//VPNDoneToolbarDelegate methods
-(void) doneToolbarButtonPushed:(id)sender;

//VPNItemGroupDelegate
-(void) didFinishSavingItemGroup;
-(void) saveFailedWithError:(NSError*)error;

//UITableView DataSource methods

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;

//UITableView Delegate methods
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
