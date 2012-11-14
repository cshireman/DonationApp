//
//  VPNOrganizationListViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 11/5/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNOrganizationListViewController.h"
#import "VPNOrganizationCell.h"

@interface VPNOrganizationListViewController ()

@end

@implementation VPNOrganizationListViewController
@synthesize organizations;
@synthesize manager;

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
    if(manager == nil)
        manager = [[VPNCDManager alloc] init];
    
    manager.delegate = self;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated
{
    //Load organizations from manager
    [manager getOrganizations:NO];
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
    return [organizations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrganizationCell";
    VPNOrganizationCell *cell = (VPNOrganizationCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(cell == nil)
    {
        cell = [[VPNOrganizationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrganizationCell"];
    }
    
    VPNOrganization* currentOrg = [organizations objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentOrg.name;
    cell.addressLabel.text = currentOrg.address;
    cell.localityLabel.text = [NSString stringWithFormat:@"%@, %@ %@",currentOrg.city, currentOrg.state, currentOrg.zip_code];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [organizations removeObjectAtIndex:indexPath.row];
    }   
}

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

-(IBAction) editPushed
{
    BOOL editing = self.tableView.editing;
    [self.tableView setEditing:!editing animated:YES];
}

#pragma mark -
#pragma mark Segue Methods

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destination = [segue destinationViewController];
    if([destination respondsToSelector:@selector(setOrganization:)])
    {
        NSIndexPath* selectedIndex = [self.tableView indexPathForCell:sender];
        if(selectedIndex != nil)
        {
            VPNOrganization* selectedOrg = [organizations objectAtIndex:selectedIndex.row];
            [destination setValue:selectedOrg forKey:@"organization"];
        }
    }
}

#pragma mark -
#pragma mark ManagerDelegate methods

-(void) didGetOrganizations:(NSArray *)newOrganizations
{
    self.organizations = newOrganizations;
    [self.tableView reloadData];
}

@end
