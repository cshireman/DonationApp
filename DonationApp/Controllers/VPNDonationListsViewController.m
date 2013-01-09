//
//  VPNDontationListsViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/4/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNDonationListsViewController.h"
#import "VPNCDManager.h"
#import "VPNItem.h"
#import "VPNOrganization.h"
#import "VPNItemList.h"
#import "VPNCashList.h"
#import "VPNMileageList.h"
#import "VPNUser.h"
#import "VPNTaxSavings.h"

@interface VPNDonationListsViewController ()
{
    NSArray* organizations;
    NSIndexPath* indexToDelete;
    VPNCDManager* manager;
    
    NSMutableArray* donationListsToDelete;
}

@end

@implementation VPNDonationListsViewController

@synthesize taxSavingsLabel;

@synthesize itemLists;
@synthesize cashLists;
@synthesize mileageLists;
@synthesize user;

@synthesize taxSavings;
@synthesize itemsTotal;
@synthesize cashTotal;
@synthesize mileageTotal;

@synthesize cashListGroup;
@synthesize mileageListGroup;

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
    manager.delegate = self;
    indexToDelete = nil;
    
    cashListGroup = [[NSMutableArray alloc] init];
    mileageListGroup = [[NSMutableArray alloc] init];
    donationListsToDelete = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated
{
    organizations = [VPNOrganization loadOrganizationsFromDisc];
    [self setTitle:[NSString stringWithFormat:@"%d Donations",user.selected_tax_year]];
    
    [self updateTotals];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(VPNDonationListGroup*) findDonationList:(VPNDonationList*)listToFind inListGroup:(NSMutableArray*)listGroup
{
    VPNDonationListGroup* foundListGroup = nil;
    for(VPNDonationListGroup* group in listGroup)
    {
        if(group.organization.ID == listToFind.companyID)
        {
            foundListGroup = group;
            break;
        }
    }
    
    return foundListGroup;
}

-(void) removeDonationList:(VPNDonationList*)listToRemove fromListGroup:(NSMutableArray*)listGroup
{
    VPNDonationListGroup* foundListGroup = [self findDonationList:listToRemove inListGroup:listGroup];
    
    if(foundListGroup == nil)
    {
        return;
    }
    
    [foundListGroup removeDonationList:listToRemove];
}

-(void) addDonationList:(VPNDonationList*)listToAdd toListGroup:(NSMutableArray*)listGroup
{
    VPNDonationListGroup* foundListGroup = [self findDonationList:listToAdd inListGroup:listGroup];
    
    if(foundListGroup == nil)
    {
        foundListGroup = [[VPNDonationListGroup alloc] init];
        foundListGroup.listType = listToAdd.listType;
        foundListGroup.organization = [self organizationForID:listToAdd.companyID];
        [listGroup addObject:foundListGroup];
    }
    
    [foundListGroup addDonationList:listToAdd];
}

-(void) updateTotals
{
    [VPNTaxSavings updateTaxSavings];
    
    itemLists = [VPNItemList loadItemListsFromDisc:user.selected_tax_year];
    cashLists = [VPNCashList loadCashListsFromDisc:user.selected_tax_year];
    mileageLists = [VPNMileageList loadMileageListsFromDisc:user.selected_tax_year];
    
    [cashListGroup removeAllObjects];
    [mileageListGroup removeAllObjects];
    
    itemsTotal = 0.00;
    cashTotal = 0.00;
    mileageTotal = 0.00;
        
    for(VPNItemList* itemList in itemLists)
    {
        itemsTotal += [itemList totalForItems];
    }
    
    for(VPNCashList* cashList in cashLists)
    {
        [self addDonationList:cashList toListGroup:cashListGroup];
        cashTotal += [cashList.cashDonation doubleValue];
    }
    
    for(VPNMileageList* mileageList in mileageLists)
    {
        [self addDonationList:mileageList toListGroup:mileageListGroup];
        mileageTotal += [mileageList.mileage doubleValue];
    }
    
    [taxSavingsLabel setText:[NSString stringWithFormat:@"$%.02f",[VPNTaxSavings currentTaxSavings]]];
    
    [self.tableView reloadData];    
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
        case 1: return [cashListGroup count];
        case 2: return [mileageListGroup count];
            
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
        
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    if(indexPath.section == 0) // Item Lists
    {
        VPNItemList* itemList = [itemLists objectAtIndex:indexPath.row];
        
        organizationLabel.text = [self organizationNameForID:itemList.companyID];
        dateLabel.text = [formatter stringFromDate:itemList.donationDate];
        amountLabel.text = [NSString stringWithFormat:@"$%.02f",[itemList totalForItems]];
    }
    else if(indexPath.section == 1) // Cash Lists
    {
        VPNDonationListGroup* listGroup = [cashListGroup objectAtIndex:indexPath.row];
        
        organizationLabel.text = listGroup.organization.name;
        dateLabel.text = [NSString stringWithFormat:@"Last Donation: %@",[formatter stringFromDate:listGroup.lastDonationDate]];
        amountLabel.text = [NSString stringWithFormat:@"$%.02f",[listGroup totalForAllLists]];
    }
    else if(indexPath.section == 2) // Mileage Lists
    {
        VPNDonationListGroup* listGroup = [mileageListGroup objectAtIndex:indexPath.row];
        
        organizationLabel.text = listGroup.organization.name;
        dateLabel.text = [NSString stringWithFormat:@"Last Donation: %@",[formatter stringFromDate:listGroup.lastDonationDate]];
        amountLabel.text = [NSString stringWithFormat:@"$%.02f",[listGroup totalForAllLists]];
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
        VPNDonationList* listToDelete = nil;
        VPNDonationListGroup* groupToDelete = nil;
        
        if(indexPath.section == 0)
        {
            //Delete from items lists
            listToDelete = [itemLists objectAtIndex:indexPath.row];
        }
        else if(indexPath.section == 1)
        {
            //Delete from cash lists
            groupToDelete = [cashListGroup objectAtIndex:indexPath.row];
        }
        else if(indexPath.section == 2)
        {
            //Delete from mileage lists
            groupToDelete = [mileageListGroup objectAtIndex:indexPath.row];
        }
        
        if(listToDelete != nil)
        {
            [manager deleteDonationList:listToDelete];
        }
        else if (groupToDelete != nil)
        {
            donationListsToDelete = [NSMutableArray arrayWithArray:groupToDelete.donationLists];
            if([donationListsToDelete count] > 0)
                [manager deleteDonationList:[donationListsToDelete objectAtIndex:0]];
            
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Selected list could not be found, please contact supper" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            
            [alert show];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Table view delegate

-(void) tableView:(UITableView *)localTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:localTableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 0:
            [self performSegueWithIdentifier:@"ManageItemListSegue" sender:[itemLists objectAtIndex:indexPath.row]];
            break;
        case 1:
            [self performSegueWithIdentifier:@"CashListSegue" sender:[cashListGroup objectAtIndex:indexPath.row]];
            break;
        case 2:
            [self performSegueWithIdentifier:@"MileageListSegue" sender:[mileageListGroup objectAtIndex:indexPath.row]];
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark VPNCDManagerDelegate methods

-(void) didDeleteList:(VPNDonationList*)list
{
    if(indexToDelete != nil)
    {
        if(indexToDelete.section == 0)
        {
            [itemLists removeObjectAtIndex:indexToDelete.row];
            [VPNItemList saveItemListsToDisc:itemLists forTaxYear:user.selected_tax_year];
            [self.tableView deleteRowsAtIndexPaths:@[indexToDelete] withRowAnimation:UITableViewRowAnimationFade];
            [self performSelector:@selector(updateTotals) withObject:nil afterDelay:0.4];
            indexToDelete = nil;
        }
        else if (indexToDelete.section == 1)
        {
            [cashLists removeObject:list];
            if([donationListsToDelete count] > 0)
                [donationListsToDelete removeObjectAtIndex:0];
            
            VPNDonationListGroup* group = [self findDonationList:list inListGroup:cashListGroup];
            if(group != nil)
            {
                [group removeDonationList:list];
                if([group.donationLists count] == 0)
                {
                    [cashListGroup removeObjectAtIndex:indexToDelete.row];
                    
                    [self.tableView deleteRowsAtIndexPaths:@[indexToDelete] withRowAnimation:UITableViewRowAnimationFade];
                    [self performSelector:@selector(updateTotals) withObject:nil afterDelay:0.4];
                    indexToDelete = nil;
                }
                else
                {
                    if([donationListsToDelete count] > 0)
                        [manager deleteDonationList:[donationListsToDelete objectAtIndex:0]];
                }
            }
                
            [VPNCashList saveCashListsToDisc:cashLists forTaxYear:user.selected_tax_year];
        }
        else if (indexToDelete.section == 2)
        {
            [mileageLists removeObject:list];
            if([donationListsToDelete count] > 0)
                [donationListsToDelete removeObjectAtIndex:0];
            
            VPNDonationListGroup* group = [self findDonationList:list inListGroup:mileageListGroup];
            if(group != nil)
            {
                [group removeDonationList:list];
                if([group.donationLists count] == 0)
                {
                    [mileageListGroup removeObjectAtIndex:indexToDelete.row];
                    
                    [self.tableView deleteRowsAtIndexPaths:@[indexToDelete] withRowAnimation:UITableViewRowAnimationFade];
                    [self performSelector:@selector(updateTotals) withObject:nil afterDelay:0.4];
                    indexToDelete = nil;
                }
                else
                {
                    if([donationListsToDelete count] > 0)
                        [manager deleteDonationList:[donationListsToDelete objectAtIndex:0]];
                }                
            }
            
            [VPNMileageList saveMileageListsToDisc:mileageLists forTaxYear:user.selected_tax_year];
        }
        
        
    }
    
}

-(void) deleteListFailedWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Deletion Error" message:@"We could not delete the specified list at this time, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alert show];
}


#pragma mark -
#pragma mark Segue Methods

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController respondsToSelector:@selector(setDonationList:)])
    {
        [segue.destinationViewController setValue:sender forKey:@"donationList"];

    }
    else if([segue.destinationViewController respondsToSelector:@selector(setGroup:)])
    {
        [segue.destinationViewController setValue:sender forKey:@"group"];
    }
}

#pragma mark -
#pragma mark Custom Methods

-(VPNOrganization*) organizationForID:(int)organizationID
{
    for(VPNOrganization* currentOrg in organizations)
    {
        if(currentOrg.ID == organizationID)
        {
            return currentOrg;
        }
    }
    
    return nil;
}

-(NSString*) organizationNameForID:(int)organizationID
{
    VPNOrganization* org = [self organizationForID:organizationID];
    if(org == nil)
        return @"Unknown";
    
    return org.name;
}

- (IBAction)editButtonPushed:(UIBarButtonItem*)sender
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

- (IBAction)addButtonPushed:(id)sender
{
    [self performSegueWithIdentifier:@"AddListSegue" sender:nil];
}
@end
