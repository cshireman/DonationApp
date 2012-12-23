//
//  VPNDoneToolbar.h
//  DonationApp
//
//  Created by Chris Shireman on 12/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNDoneToolbarDelegate.h"

@interface VPNDoneToolbar : UIView

@property (strong, nonatomic) IBOutlet UIBarButtonItem* doneButton;
@property (strong, nonatomic) id<VPNDoneToolbarDelegate> delegate;


+(UINib*) nib;
+(NSString*) nibName;
+(id) doneToolbarFromFromNib:(UINib*)nib;

-(IBAction) donePushed:(id)sender;

@end
