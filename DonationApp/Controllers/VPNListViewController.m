//
//  VPNListViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/14/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNListViewController.h"
#import "VPNCDManager.h"
#import "VPNTaxSavings.h"

@interface VPNListViewController ()
{
    NSIndexPath* indexToDelete;
    VPNCDManager* manager;
}

@end

@implementation VPNListViewController

@synthesize group;
@synthesize user;
@synthesize total;


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
    user = [VPNUser currentUser];
    
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    indexToDelete = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self updateTotals];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, 320, 21);
    UIView* headerView = [[UIView alloc] initWithFrame:frame];
    
    headerView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel.tag = kHeaderLabelTag;
    amountLabel.tag = kAmountLabelTag;
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    headerLabel.shadowOffset = CGSizeMake(0.5f, 0.5f);
    headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    headerLabel.frame = CGRectMake(20,0, 149, 21);
    headerLabel.textAlignment = UITextAlignmentLeft;
    
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.opaque = NO;
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.font = [UIFont boldSystemFontOfSize:12];
    amountLabel.shadowOffset = CGSizeMake(0.5f, 0.5f);
    amountLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    amountLabel.frame = CGRectMake(160,0, 150, 21);
    amountLabel.textAlignment = UITextAlignmentRight;
        
    [headerView addSubview:headerLabel];
    [headerView addSubview:amountLabel];
    
    return headerView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [group.donationLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DonationListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel* organizationLabel = (UILabel*)[cell viewWithTag:1];
    UILabel* dateLabel = (UILabel*)[cell viewWithTag:2];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    organizationLabel.text = group.organization.name;
    dateLabel.text = [formatter stringFromDate:group.lastDonationDate];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        indexToDelete = indexPath;
        VPNDonationList* listToDelete = nil;
        
        //Delete from items lists
        listToDelete = [group.donationLists objectAtIndex:indexPath.row];
        
        if(listToDelete != nil)
        {
            [manager deleteDonationList:listToDelete];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Selected list could not be found, please contact supper" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            
            [alert show];
        }
    }
}


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
#pragma mark VPNCDManagerDelegate methods

-(void) didDeleteList:(VPNDonationList*)list
{
    if(indexToDelete != nil)
    {
        [VPNDonationList removeDonationListFromGlobalList:list];
        [group removeDonationList:list];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexToDelete] withRowAnimation:UITableViewRowAnimationFade];
        [self performSelector:@selector(updateTotals) withObject:nil afterDelay:0.4];
        indexToDelete = nil;
    }
    
}

-(void) deleteListFailedWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Deletion Error" message:@"We could not delete the specified list at this time, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alert show];
}


#pragma mark -
#pragma mark Custom Methods

- (IBAction)editButtonPushed:(id)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (IBAction)addButtonPushed:(id)sender
{
    [self performSegueWithIdentifier:@"AddListSegue" sender:self];
}

-(void) updateTotals
{
    [VPNTaxSavings updateTaxSavings];    
    total = [group totalForAllLists];
    
    [self.tableView reloadData];
}


@end
