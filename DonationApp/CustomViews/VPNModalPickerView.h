//
//  VPNModalPickerView.h
//  DonationApp
//
//  Created by Chris Shireman on 12/20/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNModalPickerDelegate.h"

@interface VPNModalPickerView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView* picker;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* doneButton;

@property (strong, nonatomic) NSArray* options;
@property (strong, nonatomic) id<VPNModalPickerDelegate> delegate;

@property (assign) BOOL isShowing;
@property (assign) int selectedIndex;

+(NSString*) nibName;

-(id) initWithNibName:(NSString*)nibName;

-(IBAction) donePushed:(id)sender;

-(void) show;
-(void) hide;

-(void) addToView:(UIView*)view;

@end
