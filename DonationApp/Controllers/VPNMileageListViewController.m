//
//  VPNMileageListViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/13/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNMileageListViewController.h"

@interface VPNMileageListViewController ()
{
    VPNDonationList* listToManage;
}

@end

@implementation VPNMileageListViewController
@synthesize addMileageButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [addMileageButton useGreenConfirmStyle];
    
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

#pragma mark -
#pragma mark UITableViewDataSource methods

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Mileage Donations";
}

-(NSString*)tableView:(UITableView *)tableView amountForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%.02f Miles",[self.group totalForAllLists]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    VPNDonationList* donationList = [self.group.donationLists objectAtIndex:indexPath.row];
    
    // Configure the cell...
    UILabel* amountLabel = (UILabel*)[cell viewWithTag:3];
    amountLabel.text = [NSString stringWithFormat:@"%.02f Miles",[donationList.mileage doubleValue]];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    listToManage = [self.group.donationLists objectAtIndex:indexPath.row];
    listToManage.listType = MileageList;
    
    [self performSegueWithIdentifier:@"AddEditMileageListSegue" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController respondsToSelector:@selector(setDelegate:)])
    {
        [segue.destinationViewController setValue:self forKey:@"delegate"];
    }
    
    if([segue.destinationViewController respondsToSelector:@selector(setDonationList:)])
    {
        [segue.destinationViewController setValue:listToManage forKey:@"donationList"];
    }
    
    if([segue.destinationViewController respondsToSelector:@selector(setOrganization:)])
    {
        [segue.destinationViewController setValue:self.group.organization forKey:@"organization"];
    }
    
}


#pragma mark -
#pragma mark Custom Methods

- (IBAction)addButtonPushed:(id)sender
{
    listToManage = [[VPNDonationList alloc] init];
    listToManage.listType = MileageList;
    
    [self performSegueWithIdentifier:@"AddEditMileageListSegue" sender:self];
}


- (void)viewDidUnload {
    [self setAddMileageButton:nil];
    [super viewDidUnload];
}
@end
