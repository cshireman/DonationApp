//
//  VPNLoginViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 10/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNCDManagerDelegate.h"
#import "VPNCDManager.h"
#import "VPNUser.h"
#import "VPNNotifier.h"

@class VPNLoginViewController;
@protocol VPNLoginViewControllerDelegate <NSObject>

-(void) loginControllerFinished;

@end

@interface VPNLoginViewController : UIViewController <UITextFieldDelegate,VPNCDManagerDelegate>

@property (strong, nonatomic) id<VPNLoginViewControllerDelegate> delegate;
@property (strong, nonatomic) VPNCDManager* manager;
@property (strong, nonatomic) VPNUser* user;

@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) IBOutlet UITextField* usernameField;
@property (strong, nonatomic) IBOutlet UITextField* passwordField;

-(IBAction) loginPushed:(id) sender;
-(IBAction) dismissKeyboard;

//VPNCDManagerDelegate methods
-(void) startingSessionFailedWithError:(NSError*)error;
-(void) didStartSession;

-(void) getUserInfoFailedWithError:(NSError *)error;
-(void) didGetUser:(VPNUser *)user;

-(void) getTaxYearsFailedWithError:(NSError *)error;
-(void) didGetTaxYears:(NSArray *)taxYears;

-(void) didGetOrganizations:(NSArray*)organizations;
-(void) getOrganizationsFailedWithError:(NSError*)error;



@end
