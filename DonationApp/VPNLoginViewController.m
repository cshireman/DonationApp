//
//  VPNLoginViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNLoginViewController.h"
#import "VPNUser.h"

@interface VPNLoginViewController ()

@end

@implementation VPNLoginViewController
@synthesize usernameField;
@synthesize passwordField;
@synthesize scrollView;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{    
    NSLog(@"Delegate: %@",self.delegate);
    [super viewDidLoad];
    VPNUser* user = [VPNUser loadUserFromDisc];
    if(user != nil)
    {
        self.usernameField.text = user.username;
        self.passwordField.text = user.password;
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
    
    VPNUser* user = [[VPNUser alloc] init];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;

    if([user authenticate])
    {
        if(self.delegate != nil)
        {
            [self.delegate loginController:self didFinish:YES];
        }
    }
    else
    {
        NSLog(@"User is not valid");
        if(self.delegate != nil)
        {
            [self.delegate loginController:self didFinish:NO];
        }
        else
        {
            NSLog(@"Delegate is Nil!");
        }
    }
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

@end
