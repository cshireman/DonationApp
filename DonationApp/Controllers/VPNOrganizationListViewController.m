//
//  VPNOrganizationListViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 11/5/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNOrganizationListViewController.h"
#import "VPNOrganizationCell.h"
#import "VPNUser.h"

@interface VPNOrganizationListViewController ()
{
    NSIndexPath* deleteIndexPath;
    VPNUser* user;
}

@end

@implementation VPNOrganizationListViewController
@synthesize organizations;
@synthesize manager;
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
    if(manager == nil)
        manager = [[VPNCDManager alloc] init];
    
    manager.delegate = self;
    user = [VPNUser currentUser];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAds) name:@"RemoveAds" object:nil];
    
    if(!user.is_trial)
        [self removeAds];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated
{
    //Load organizations from manager
    [manager getOrganizations:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) removeAds
{
    [self.bannerView setHidden:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        deleteIndexPath = indexPath;
        
        UIActionSheet* deleteConfirm = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this Organization?  It cannot be undone." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
        
        [deleteConfirm showFromTabBar:self.tabBarController.tabBar];
        
        
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.destructiveButtonIndex)
    {
        VPNOrganization* orgToDelete = [organizations objectAtIndex:deleteIndexPath.row];
        [manager deleteOrganization:orgToDelete];
    }
    
    [actionSheet resignFirstResponder];
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

-(IBAction) editPushed:(UIBarButtonItem*)sender
{
    BOOL editing = self.tableView.editing;
    
    if(!editing)
    {
        [sender setTitle:@"Cancel"];
        sender.tintColor = [UIColor blueColor];
    }
    else
    {
        [sender setTitle:@"Edit"];
        sender.tintColor = nil;
    }
    
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
#pragma mark AdBannerViewDelegate Methods

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self.bannerView setHidden:YES];
}


#pragma mark -
#pragma mark ManagerDelegate methods

-(void) didGetOrganizations:(NSArray *)newOrganizations
{
    self.organizations = [NSMutableArray array];
    
    for(VPNOrganization* newOrg in newOrganizations)
    {
        if(newOrg.is_active)
        {
            [self.organizations addObject:newOrg];
        }
    }
    
    [self.tableView reloadData];
}

-(void) getOrganizationsFailedWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"Can't download organizations at this time, please try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) didDeleteOrganization
{
    if(deleteIndexPath != nil)
    {
        [organizations removeObjectAtIndex:deleteIndexPath.row];
        [VPNOrganization saveOrganizationsToDisc:organizations];
        [self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];        
    }
}

-(void) deleteOrganizationFailedWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Delete Error" message:@"Can't delete organization at this time, please try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];    
}

@end
