//
//  VPNUserSignupViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNUserSignupViewController.h"
#import "VPNUser.h"

@interface VPNUserSignupViewController ()

@end

@implementation VPNUserSignupViewController
@synthesize taxYearTable;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    cell.textLabel.text = @"Year";
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    return cell;
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.confirmPasswordField)
    {
        [self.confirmPasswordField resignFirstResponder];
        return YES;
    }
    else if(textField == self.firstNameField)
    {
        [self.lastNameField becomeFirstResponder];
        return NO;
    }
    else if(textField == self.lastNameField)
    {
        [self.emailField becomeFirstResponder];
        return NO;
    }
    else if(textField == self.emailField)
    {
        [self.passwordField becomeFirstResponder];
        return NO;
    }
    else if(textField == self.passwordField)
    {
        [self.confirmPasswordField becomeFirstResponder];
        return NO;
    }

    [textField resignFirstResponder];
    return NO;
}

#pragma mark -
#pragma mark Customer Methods

-(IBAction)cancelPushed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitPushed:(id)sender
{
    VPNUser* user = [[VPNUser alloc] init];
    
    user.first_name = self.firstNameField.text;
    user.last_name = self.lastNameField.text;
    user.username = self.emailField.text;
    user.password = self.passwordField.text;
    user.is_email_opted_in = YES;
    
    user.tax_years = [[NSMutableArray alloc] initWithCapacity:1];
    [user.tax_years addObject:@"2012"];
    
    [user saveAsDefaultUser];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
