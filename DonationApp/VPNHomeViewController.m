//
//  VPNHomeViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/16/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNHomeViewController.h"
#import "VPNMainTabGroupViewController.h"

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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    VPNMainTabGroupViewController* tabBarController = (VPNMainTabGroupViewController*)self.navigationController.tabBarController;
    [tabBarController displayLoginScene];
}

-(IBAction) updatePushed:(id)sender
{
    
}

/**
 * Calculate the tax savings amount based on donation amounts and tax rate
 */
-(double) calculateTaxSavingsWithItemAmount:(double)itemAmount moneyAmount:(double)moneyAmount mileageAmount:(double)mileageAmount taxRate:(double)taxRate;
{
    return taxRate*(itemAmount+moneyAmount+(0.14*mileageAmount));
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
    [userDefaults setDouble:25.00 forKey:kTaxSavingsKey];
    [userDefaults synchronize];
}


@end
