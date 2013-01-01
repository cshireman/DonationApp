//
//  VPNLoginViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNLoginViewController.h"
#import "VPNUser.h"
#import "DejalActivityView.h"

@interface VPNLoginViewController ()

@end

@implementation VPNLoginViewController
@synthesize usernameField;
@synthesize passwordField;
@synthesize scrollView;
@synthesize delegate;
@synthesize manager;
@synthesize user;

@synthesize signUpButton;
@synthesize loginButton;

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
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    [self configure];
        
    scrollView.contentSize = CGSizeMake(320, 700);
    self.scrollView.scrollEnabled = NO;
    
    [signUpButton useSimpleOrangeStyle];
    [loginButton useGreenConfirmStyle];
}

-(void) viewWillAppear:(BOOL)animated
{
    user = [VPNUser currentUser];
    usernameField.text = user.username;
    passwordField.text = user.password;    
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
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Logging in" width:155];
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
    [DejalBezelActivityView removeViewAnimated:YES];
    [VPNNotifier postNotification:@"InvalidLoginError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Invalid Username or Password" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) didStartSession
{
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading user info";
    [manager getUserInfo:YES];
}

-(void) getUserInfoFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [VPNNotifier postNotification:@"GetUserInfoError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"We were not able to retrieve your user information at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) didGetUser:(VPNUser *)theUser
{
    NSParameterAssert(theUser != nil);
    
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading tax years";
    [manager getTaxYears:YES];
}

-(void) getTaxYearsFailedWithError:(NSError *)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
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
    
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading Purchase Options";
    [manager getPurchaseOptions];
}

-(void) didGetPurchaseOptions:(NSDictionary *)info
{
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading Organizations";
    [manager getOrganizations:YES];
}

-(void) didGetOrganizations:(NSArray*)organizations
{
    [DejalBezelActivityView removeViewAnimated:YES];
    NSParameterAssert(organizations != nil);
    
    [delegate loginControllerFinished];
}

-(void) getOrganizationsFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [VPNNotifier postNotification:@"GetOrganizationsError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"We were not able to retrieve your organization information at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
    
}


@end
