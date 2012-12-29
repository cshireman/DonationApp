//
//  VPNEditItemViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/28/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNItemGroup.h"
#import "VPNItemGroupDelegate.h"
#import "VPNItemConditionCellDelegate.h"
#import "VPNItemConditionCell.h"
#import "VPNDoneToolbarDelegate.h"
#import "VPNDoneToolbar.h"

@interface VPNEditItemViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,VPNItemConditionCellDelegate,VPNDoneToolbarDelegate,VPNItemGroupDelegate,VPNCDManagerDelegate>

@property (retain, nonatomic) UINib* itemCellNib;
@property (retain, nonatomic) UINib* doneToolbarNib;

@property (strong, nonatomic) VPNItemGroup* group;
@property (strong, nonatomic) VPNDoneToolbar* doneToolbar;

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* doneButton;

-(IBAction) doneButtonPushed:(id)sender;

//VPNDoneToolbarDelegate methods
-(void) doneToolbarButtonPushed:(id)sender;

//VPNItemGroupDelegate
-(void) didFinishSavingItemGroup;
-(void) saveFailedWithError:(NSError*)error;

@end
