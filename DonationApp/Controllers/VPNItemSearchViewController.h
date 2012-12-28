//
//  VPNItemSearchViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/26/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNDonationList.h"

@interface VPNItemSearchViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray* results;
@property (strong, nonatomic) VPNDonationList* donationList;

@property (strong, nonatomic) IBOutlet UISearchBar* itemSearchBar;
@end
