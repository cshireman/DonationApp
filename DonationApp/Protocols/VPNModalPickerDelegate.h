//
//  VPNModalPickerDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 12/20/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPNModalPickerDelegate <NSObject>

-(void) optionWasSelectedAtIndex:(int)selectedIndex;
-(void) pickerWasDismissed;
-(void) pickerWasDisplayed;

@end
