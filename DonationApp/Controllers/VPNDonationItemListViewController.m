//
//  VPNDonationItemListViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/12/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNDonationItemListViewController.h"

@interface VPNDonationItemListViewController ()

@end

@implementation VPNDonationItemListViewController

@synthesize organizationLabel;
@synthesize donationListInfoLabel;
@synthesize tableView;
@synthesize donationList;
@synthesize organization;
@synthesize itemGroups;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(organization == nil)
        organization = [VPNOrganization organizationForID:donationList.companyID];
    
    [self updateHeaderInfo];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark -
#pragma mark Custom Methods

-(IBAction) backPushed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)addCustomItemPushed:(id)sender {
    [self performSegueWithIdentifier:@"EditCustomItemSegue" sender:self];
}

- (IBAction)addItemPushed:(id)sender {
    [self performSegueWithIdentifier:@"ItemSearchSegue" sender:self];
}

- (IBAction)editListPushed:(id)sender {
    [self performSegueWithIdentifier:@"EditDonationListSegue" sender:self];
}

- (IBAction)editPushed:(id)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}

-(void) updateHeaderInfo
{    
    organizationLabel.text = organization.name;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString* listDate = [formatter stringFromDate:donationList.donationDate];
    NSString* itemSource = donationList.howAquired;
    
    donationListInfoLabel.text = [NSString stringWithFormat:@"%@ (%@)",listDate,itemSource];
}

#pragma mark -
#pragma mark Segue Methods

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController respondsToSelector:@selector(setDelegate:)])
    {
        [segue.destinationViewController setValue:self forKey:@"delegate"];
    }
    
    if([segue.destinationViewController respondsToSelector:@selector(setDonationList:)])
    {
        [segue.destinationViewController setValue:donationList forKey:@"donationList"];
    }
    
    if([segue.destinationViewController respondsToSelector:@selector(setOrganization:)])
    {
        [segue.destinationViewController setValue:organization forKey:@"organization"];
    }
    
}

#pragma mark -
#pragma mark VPNCDManagerDelegate Methods

-(void)didDeleteListItem:(id)item
{
    
}

-(void)deleteListItemFailedWithError:(NSError *)error
{
    
}

#pragma mark -
#pragma mark VPNEditDonationListDelegate Methods

-(void)didFinishEditingDonationList:(VPNDonationList *)localDonationList
{
    donationList = localDonationList;
    if(donationList.companyID != organization.ID)
    {
        organization = [VPNOrganization organizationForID:donationList.companyID];
    }

    [self updateHeaderInfo];
}

- (void)viewDidUnload {
    [self setOrganizationLabel:nil];
    [self setDonationListInfoLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
