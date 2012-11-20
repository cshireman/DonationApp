//
//  VPNHomeViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/16/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNHomeViewController.h"
#import "VPNMainTabGroupViewController.h"
#import "VPNContactInfoCell.h"
#import "VPNPasswordCell.h"
#import "VPNTaxRateCell.h"

#define kTaxSettingsSection     0
#define kPasswordSection        1
#define kContactInfoSection     2
#define kContactUsSection       3

@interface VPNHomeViewController ()

@end

@implementation VPNHomeViewController
@synthesize updateButton;
@synthesize optOutView;
@synthesize optOutSwitch;
@synthesize bannerView;
@synthesize session;
@synthesize user;
@synthesize nameField;
@synthesize emailField;
@synthesize passwordField;
@synthesize confirmPasswordField;
@synthesize taxSavingsLabel;
@synthesize manager;

-(id) init
{
    self = [super init];
    if(self)
    {
        [self configure];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self configure];
    }
    return self;
}

-(void) configure
{
    session = [VPNSession currentSession];
    user = [VPNUser currentUser];
    manager = [[VPNCDManager alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
    
    [self.tableView registerClass:[VPNContactInfoCell class] forCellReuseIdentifier:@"ContactInfoCell"];
    [self.tableView registerClass:[VPNPasswordCell class] forCellReuseIdentifier:@"ChangePasswordCell"];
    [self.tableView registerClass:[VPNTaxRateCell class] forCellReuseIdentifier:@"MyTaxSavingsCell"];
    
    NSLog(@"%@ %@",user.first_name, user.last_name);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinished) name:@"LoginFinished" object:nil];

    //Load up cells to get field and label references
    NSIndexPath* contactInfoIndexPath = [NSIndexPath indexPathForRow:0 inSection:kContactInfoSection];
    NSIndexPath* changePasswordIndexPath = [NSIndexPath indexPathForRow:0 inSection:kPasswordSection];
    NSIndexPath* taxSavingsIndexPath = [NSIndexPath indexPathForRow:1 inSection:kTaxSettingsSection];
    
    [self tableView:self.tableView cellForRowAtIndexPath:contactInfoIndexPath];
    [self tableView:self.tableView cellForRowAtIndexPath:changePasswordIndexPath];
    [self tableView:self.tableView cellForRowAtIndexPath:taxSavingsIndexPath];
    
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) loginFinished
{
    user = [VPNUser currentUser];
    session = [VPNSession currentSession];
    
    [self.tableView reloadData];
    [optOutSwitch setOn:user.is_email_opted_in];
}

-(void) viewDidUnload
{
    self.updateButton = nil;
    self.optOutView = nil;
    self.optOutSwitch = nil;
    self.bannerView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == kTaxSettingsSection)
        return 2;
    
    return 1;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == kContactInfoSection)
    {
        //Remove the opt out view from the super view.  Will be added to section footer later
        [self.optOutView removeFromSuperview];
        return self.optOutView;
    }
    
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == kContactInfoSection)
        return 44;
    
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == kPasswordSection || indexPath.section == kContactInfoSection)
        return 118;
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if(indexPath.section == kTaxSettingsSection)
    {
        if(indexPath.row == 0)
            CellIdentifier = @"MyTaxYearsCell";
        else
            CellIdentifier = @"MyTaxSavingsCell";
    }
    else if(indexPath.section == kPasswordSection)
    {
        CellIdentifier = @"ChangePasswordCell";
    }
    else if(indexPath.section == kContactInfoSection)
    {
        CellIdentifier = @"ContactInfoCell";
    }
    else if(indexPath.section == kContactUsSection)
    {
        CellIdentifier = @"ContactUsCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if([CellIdentifier isEqualToString:@"ContactInfoCell"])
    {
        VPNContactInfoCell* contactCell = (VPNContactInfoCell*)cell;
        if(nameField == nil)
            nameField = contactCell.nameField;
        
        if(emailField == nil)
            emailField = contactCell.emailField;
        
        nameField.text = [NSString stringWithFormat:@"%@ %@",user.first_name,user.last_name];
        emailField.text = user.email;
    }
    else if([CellIdentifier isEqualToString:@"ChangePasswordCell"])
    {
        VPNPasswordCell* passwordCell = (VPNPasswordCell*)cell;
        
        if(passwordField == nil)
            passwordField = passwordCell.passwordField;
        
        if(confirmPasswordField == nil)
            confirmPasswordField = passwordCell.confirmPasswordField;
    }
    else if([CellIdentifier isEqualToString:@"MyTaxSavingsCell"])
    {
        VPNTaxRateCell* taxSavingsCell = (VPNTaxRateCell*)cell;
        taxSavingsLabel = taxSavingsCell.taxSavings;
        
        taxSavingsLabel.text = [NSString stringWithFormat:@"$%.02f",[VPNTaxSavings currentTaxSavings]];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == kTaxSettingsSection)
    {
        VPNMainTabGroupViewController* tabBarController = (VPNMainTabGroupViewController*)self.tabBarController;

        if(indexPath.row == 0)
            [tabBarController displaySelectTaxYearScene];
        else
            [self performSegueWithIdentifier:@"SelectTaxRateSegue" sender:self];
        
    }
}

#pragma mark -
#pragma mark Segue Methods

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destination = (UIViewController*)segue.destinationViewController;
    if([destination respondsToSelector:@selector(setDelegate:)])
        [destination setValue:self forKey:@"delegate"];
}

#pragma mark -
#pragma mark AdBannerViewDelegate Methods

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self.bannerView setHidden:YES];
}

#pragma mark -
#pragma mark Custom Methods

-(IBAction) logoutPushed:(id)sender
{
    [VPNSession clearCurrentSession];
    session = [VPNSession currentSession];
    
    user = [VPNUser currentUser];
    user.selected_tax_year = 0;
    [user saveAsDefaultUser];
    
    [VPNNotifier postNotification:@"Logout"];
}

-(IBAction) updatePushed:(id)sender
{
    NSString* password = passwordField.text;
    NSString* confirmPassword = confirmPasswordField.text;
    
    if([password length] > 0 || [confirmPassword length] > 0)
    {
        if([password isEqualToString:confirmPassword])
        {
            [VPNNotifier postNotification:@"PasswordsMatch"];
            [manager changePassword:password];
        }
        else
        {
            [VPNNotifier postNotification:@"PasswordMismatchError"];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"The passwords you entered do not match, please try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
    [manager getUserInfo:YES];
}


#pragma mark -
#pragma mark VPNSelectTaxRateViewControllerDelegate Methods
-(void) selectTaxRateCanceled
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) selectTaxRateSaved
{
    [self dismissModalViewControllerAnimated:YES];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* selectedTaxRate=  [userDefaults objectForKey:kSelectedTaxRateKey];
    
    double taxRate = [VPNTaxSavings doubleForTaxRate:selectedTaxRate];
    
    [userDefaults setDouble:taxRate forKey:kTaxSavingsKey];
    [userDefaults synchronize];
}

#pragma mark -
#pragma mark VPNCDManagerDelegateMethods

-(void) didChangePassword
{
    [VPNNotifier postNotification:@"UserInfoUpdated"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your password has been saved!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];    
}

-(void) changePasswordFailedWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Password Update Error" message:@"We could not save your password at this time, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) didUpdateUserInfo
{
    [VPNNotifier postNotification:@"UserInfoUpdated"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your information has been saved!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) updateUserInfoFailedWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Update Error" message:@"We could not save your information at this time, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) didGetUser:(VPNUser*)theUser
{
    NSString* name = nameField.text;
    NSString* email = emailField.text;
    
    NSArray* nameParts = [name componentsSeparatedByString:@" "];
    if(nil != nameParts && [nameParts count] > 0)
    {
        NSInteger lastIndex = [nameParts count] - 1;
        theUser.first_name = [nameParts objectAtIndex:0];
        theUser.last_name = [nameParts objectAtIndex:lastIndex];
    }
    else
    {
        theUser.first_name = name;
    }
    
    theUser.email = email;
    
    [manager updateUserInfo:user];
}

-(void) getUserInfoFailedWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Update Error" message:@"We could not save your information at this time, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];    
}


@end
