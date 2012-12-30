//
//  VPNUserSignupViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/18/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNUserSignupViewController.h"
#import "VPNUser.h"
#import "VPNCDManager.h"
#import "DejalActivityView.h"

@interface VPNUserSignupViewController ()
{
    int currentYear;
    int prevYear;
    int selectedTaxYear;
    
    VPNCDManager* manager;
}
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
    
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    NSDate* today = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:today];
    
    currentYear = [components year];
    prevYear = currentYear - 1;
    
    selectedTaxYear = currentYear;
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
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%d",prevYear];
        if(selectedTaxYear == prevYear)
            cell.imageView.image = [UIImage imageNamed:@"checkbox_checked"];
        else
            cell.imageView.image = [UIImage imageNamed:@"checkbox_unchecked"];
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%d",currentYear];
        if(selectedTaxYear == currentYear)
            cell.imageView.image = [UIImage imageNamed:@"checkbox_checked"];
        else
            cell.imageView.image = [UIImage imageNamed:@"checkbox_unchecked"];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        selectedTaxYear = prevYear;
    else if(indexPath.row == 1)
        selectedTaxYear = currentYear;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
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
#pragma mark VPNCDManagerDelegate Methods

-(void) didRegisterTrialUser:(VPNUser *)user
{
    [DejalBezelActivityView removeViewAnimated:YES];
    
    user.tax_years = [[NSMutableArray alloc] initWithCapacity:1];
    [user.tax_years addObject:@"2012"];
    
    [user saveAsDefaultUser];
    [VPNUser saveUserToDisc:user];
    [self.navigationController popViewControllerAnimated:YES];    
}

-(void) registerTrialUserFailedWithError:(NSError *)error
{
    [DejalBezelActivityView removeViewAnimated:YES];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Registration Error" message:@"Unable to create your account at this time, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

#pragma mark -
#pragma mark Customer Methods

-(IBAction)cancelPushed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitPushed:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Registering" width:155];
    
    VPNUser* user = [[VPNUser alloc] init];
    
    user.first_name = self.firstNameField.text;
    user.last_name = self.lastNameField.text;
    user.username = self.emailField.text;
    user.password = self.passwordField.text;
    user.email = self.emailField.text;
    user.is_email_opted_in = YES;
    
    [manager registerTrialUser:user withTaxYear:selectedTaxYear];
}


@end
