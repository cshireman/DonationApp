//
//  VPNSelectTaxRateViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSelectedTaxRateKey     @"selected_tax_rate"

@class VPNSelectTaxRateViewController;
@protocol VPNSelectTaxRateViewControllerDelegate <NSObject>

-(void) selectTaxRateCanceled;
-(void) selectTaxRateSaved;

@end

@interface VPNSelectTaxRateViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) id<VPNSelectTaxRateViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray* taxRates;
@property (copy, nonatomic) NSString* selectedTaxRate;

@property (strong, nonatomic) IBOutlet UITableView* taxRateTable;

-(IBAction)savePushed:(id)sender;
-(IBAction)cancelPushed:(id)sender;

-(void) config;

//UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//UITableViewDataSource Methods
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
@end
