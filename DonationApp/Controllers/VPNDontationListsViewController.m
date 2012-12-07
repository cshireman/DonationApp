//
//  VPNDontationListsViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/4/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNDontationListsViewController.h"
#import "VPNCDManager.h"
#import "VPNItem.h"
#import "VPNOrganization.h"
#import "VPNItemList.h"
#import "VPNCashList.h"
#import "VPNMileageList.h"
#import "VPNUser.h"
#import "VPNTaxSavings.h"

@interface VPNDontationListsViewController ()
{
    NSArray* organizations;
    NSIndexPath* indexToDelete;
    VPNCDManager* manager;
}

@end

@implementation VPNDontationListsViewController

@synthesize taxSavingsLabel;

@synthesize itemLists;
@synthesize cashLists;
@synthesize mileageLists;
@synthesize user;

@synthesize taxSavings;
@synthesize itemsTotal;
@synthesize cashTotal;
@synthesize mileageTotal;

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

    [VPNTaxSavings updateTaxSavings];
    user = [VPNUser currentUser];
    
    manager = [[VPNCDManager alloc] init];
    indexToDelete = nil;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated
{
    organizations = [VPNOrganization loadOrganizationsFromDisc];
    [self setTitle:[NSString stringWithFormat:@"%d Donations",user.selected_tax_year]];
    
    itemLists = [VPNItemList loadItemListsFromDisc:user.selected_tax_year];
    cashLists = [VPNCashList loadCashListsFromDisc:user.selected_tax_year];
    mileageLists = [VPNMileageList loadMileageListsFromDisc:user.selected_tax_year];
    
    itemsTotal = 0.00;
    cashTotal = 0.00;
    mileageTotal = 0.00;
    
    for(VPNItemList* itemList in itemLists)
    {
        itemsTotal += [itemList totalForItems];
    }
    
    for(VPNCashList* cashList in cashLists)
    {
        cashTotal += [cashList.cashDonation doubleValue];
    }

    for(VPNMileageList* mileageList in mileageLists)
    {
        mileageTotal += [mileageList.mileage doubleValue];
    }
    
    [taxSavingsLabel setText:[NSString stringWithFormat:@"$%.02f",[VPNTaxSavings currentTaxSavings]]];
    
    [self.tableView reloadData];
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
    
    if(section == 0)
    {
        headerLabel.text = @"Item Donations";
        amountLabel.text = [NSString stringWithFormat:@"$%.02f",itemsTotal];
    }
    else if(section == 1)
    {
        headerLabel.text = @"Money Donations";
        amountLabel.text = [NSString stringWithFormat:@"$%.02f",cashTotal];
    }
    else if(section == 2)
    {
        headerLabel.text = @"Mileage Donations";
        amountLabel.text = [NSString stringWithFormat:@"%d miles",mileageTotal];
    }
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch(section)
    {
        case 0: return [itemLists count];
        case 1: return [cashLists count];
        case 2: return [mileageLists count];
            
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DonationListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel* organizationLabel = (UILabel*)[cell viewWithTag:1];
    UILabel* dateLabel = (UILabel*)[cell viewWithTag:2];
    UILabel* amountLabel = (UILabel*)[cell viewWithTag:3];
        
    if(indexPath.section == 0) // Item Lists
    {
        VPNItemList* itemList = [itemLists objectAtIndex:indexPath.row];
        
        organizationLabel.text = [self organizationNameForID:itemList.companyID];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        
        dateLabel.text = [formatter stringFromDate:itemList.donationDate];
        
        amountLabel.text = [NSString stringWithFormat:@"$%.02f",[itemList totalForItems]];
    }
    else if(indexPath.section == 1) // Cash Lists
    {
        VPNCashList* cashList = [cashLists objectAtIndex:indexPath.row];
        
        organizationLabel.text = [self organizationNameForID:cashList.companyID];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        
        dateLabel.text = [NSString stringWithFormat:@"Last Donation: %@",[formatter stringFromDate:cashList.donationDate]];
        
        amountLabel.text = [NSString stringWithFormat:@"$%.02f",[cashList.cashDonation doubleValue]];
    }
    else if(indexPath.section == 2) // Mileage Lists
    {
        VPNMileageList* mileageList = [mileageLists objectAtIndex:indexPath.row];
        
        organizationLabel.text = [self organizationNameForID:mileageList.companyID];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        
        dateLabel.text = [NSString stringWithFormat:@"Last Entry: %@",[formatter stringFromDate:mileageList.donationDate]];
        
        amountLabel.text = [NSString stringWithFormat:@"%d Miles",[mileageList.mileage intValue]];
    }
    
    
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
        indexToDelete = indexPath;

        if(indexPath.section == 0)
        {
            //Delete from items lists
        }
        else if(indexPath.section == 1)
        {
            //Delete from cash lists
        }
        else if(indexPath.section == 2)
        {
            //Delete from mileage lists
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
#pragma mark VPNCDManagerDelegate methods

-(void) didDeleteList:(id)list
{
    if(indexToDelete != nil)
    {
        if(indexToDelete.section == 0)
            [itemLists removeObjectAtIndex:indexToDelete.row];
        else if (indexToDelete.section == 1)
            [cashLists removeObjectAtIndex:indexToDelete.row];
        else if (indexToDelete.section == 2)
            [mileageLists removeObjectAtIndex:indexToDelete.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexToDelete] withRowAnimation:UITableViewRowAnimationFade];
        indexToDelete = nil;
    }
    
}

-(void) deleteListFailedWithError:(NSError *)error
{
    
}


#pragma mark -
#pragma mark Custom Methods

-(NSString*) organizationNameForID:(int)organizationID
{
    for(VPNOrganization* currentOrg in organizations)
    {
        if(currentOrg.ID == organizationID)
        {
            return currentOrg.name;
        }
    }

    return @"Unknown";
}

- (IBAction)editButtonPushed:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (IBAction)addButtonPushed:(id)sender {
}
@end
