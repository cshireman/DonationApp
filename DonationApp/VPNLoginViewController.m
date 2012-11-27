//
//  VPNLoginViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNLoginViewController.h"
#import "VPNOverlayViewController.h"
#import "VPNUser.h"

@interface VPNLoginViewController ()
{
    VPNOverlayViewController* loading;
}

@end

@implementation VPNLoginViewController
@synthesize usernameField;
@synthesize passwordField;
@synthesize scrollView;
@synthesize delegate;
@synthesize manager;
@synthesize user;

-(id)init
{
    self = [super init];
    if(self)
    {
        [self configure];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self configure];
    }
    return self;
}

/**
 Configure the manager and other default structures
 */
-(void) configure
{
    if(manager == nil)
        manager = [[VPNCDManager alloc] init];
    
    if(manager.delegate == nil)
        manager.delegate = self;
    
    if(user == nil)
    {
        user = [VPNUser currentUser];
    }

    loading = [[VPNOverlayViewController alloc] init];
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    [self configure];
    
    if(user != nil)
    {
        usernameField.text = user.username;
        passwordField.text = user.password;
    }
    
    scrollView.contentSize = CGSizeMake(320, 700);
    self.scrollView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Custom Methods

-(IBAction) loginPushed:(id)sender
{
    user.username = usernameField.text;
    user.password = passwordField.text;
    
    user.username = [user.username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    user.password = [user.password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([user.username isEqualToString:@""])
    {
        [VPNNotifier postNotification:@"BlankUsernameError"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Username is a required field" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    if([user.password isEqualToString:@""])
    {
        [VPNNotifier postNotification:@"BlankPasswordError"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Password is a required field" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    [loading setDescriptionText:@"Logging in"];
    [loading show];
    [manager startSessionForUser:user];
}

-(IBAction)cancelPushed:(id)sender
{
}

-(IBAction) dismissKeyboard
{
    NSLog(@"Dismissing Keyboard");
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scrollView scrollRectToVisible:CGRectZero animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldFrame = textField.frame;
    textFieldFrame.origin.y += 240;
    
    [self.scrollView scrollRectToVisible:textFieldFrame animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGRect top = CGRectMake(0, 0, 320, 1);
    [self.scrollView scrollRectToVisible:top animated:YES];
    return YES;
}

#pragma mark -
#pragma mark VPNCDManagerDelegate methods

-(void) startingSessionFailedWithError:(NSError*)error
{
    [loading hide];
    [VPNNotifier postNotification:@"InvalidLoginError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Invalid Username or Password" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) didStartSession
{
    [loading setDescriptionText:@"Loading user info"];
    [loading setProgressPercent:25.0];
    [manager getUserInfo:YES];
}

-(void) getUserInfoFailedWithError:(NSError*)error
{
    [loading hide];
    [VPNNotifier postNotification:@"GetUserInfoError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"We were not able to retrieve your user information at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) didGetUser:(VPNUser *)theUser
{
    NSParameterAssert(theUser != nil);
    
    [loading setDescriptionText:@"Loading tax years"];
    [loading setProgressPercent:50.0];
    [manager getTaxYears:YES];
}

-(void) getTaxYearsFailedWithError:(NSError *)error
{
    [loading hide];
    [VPNNotifier postNotification:@"GetTaxYearsError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"We were not able to retrieve your tax year information at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
    
}

-(void) didGetTaxYears:(NSArray *)taxYears
{
    NSParameterAssert(taxYears != nil);
    if([taxYears count] == 0)
    {
        [VPNNotifier postNotification:@"GetTaxYearsEmptyError"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"We were not able to retrieve your tax year information at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    [loading setDescriptionText:@"Loading organizations"];
    [loading setProgressPercent:75.0];
    [manager getOrganizations:YES];
}

-(void) didGetOrganizations:(NSArray*)organizations
{
    [loading hide];
    NSParameterAssert(organizations != nil);
    
    [delegate loginControllerFinished];
}

-(void) getOrganizationsFailedWithError:(NSError*)error
{
    [loading hide];
    [VPNNotifier postNotification:@"GetOrganizationsError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"We were not able to retrieve your organization information at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
    
}


@end
