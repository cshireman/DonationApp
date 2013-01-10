//
//  VPNDonationItemListViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/12/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNDonationItemListViewController.h"
#import "VPNItemGroup.h"
#import "VPNItemList.h"
#import "DejalActivityView.h"

#import "Item.h"
#import "Category.h"

@interface VPNDonationItemListViewController ()
{
    NSArray* conditionNames;
    VPNItemGroup* groupToEdit;
    VPNCDManager* manager;
}

@end

@implementation VPNDonationItemListViewController

@synthesize organizationLabel;
@synthesize donationListInfoLabel;
@synthesize tableView;
@synthesize donationList;
@synthesize organization;
@synthesize itemGroups;
@synthesize addCustomItemButton;
@synthesize addEbayItemButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View Did Load");
    
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    [addCustomItemButton useGreenConfirmStyle];
    [addEbayItemButton useGreenConfirmStyle];
    
    conditionNames = @[@"Fair",@"Good",@"Very Good",@"Excellent",@"Mint/New"];
    
    if(organization == nil)
        organization = [VPNOrganization organizationForID:donationList.companyID];
    
    [self updateHeaderInfo];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) refreshItemGroups
{
    //Reload the donation list from disc when the view appears - get most up to date information
    if(donationList != nil)
    {
        VPNUser* user = [VPNUser currentUser];
        NSArray* itemLists = [VPNItemList loadItemListsFromDisc:user.selected_tax_year];
        
        for(VPNDonationList* currentList in itemLists)
        {
            if(currentList.ID == donationList.ID)
            {
                donationList = currentList;
            }
        }
    }
    
    itemGroups = [NSMutableArray arrayWithArray:[VPNItemGroup groupsFromItemsInDonationList:donationList]];
    [self.tableView reloadData];    
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"View Will Appear");
    [super viewWillAppear:animated];
    [self refreshItemGroups];
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"View Did Appear");
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VPNItemGroup* itemGroup = [itemGroups objectAtIndex:indexPath.row];
    return 90+([itemGroup.conditions count]*15);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [itemGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemGroupCell";
    UITableViewCell *cell = [localTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    VPNItemGroup* itemGroup = [itemGroups objectAtIndex:indexPath.row];
    
    UILabel* categoryLabel = (UILabel*)[cell viewWithTag:1];
    UILabel* itemNameLabel = (UILabel*)[cell viewWithTag:2];
    UILabel* qtyHeader = (UILabel*)[cell viewWithTag:3];
    UILabel* conditionHeader = (UILabel*)[cell viewWithTag:4];
    UILabel* fmvHeader = (UILabel*)[cell viewWithTag:5];
    UILabel* subtotalHeader = (UILabel*)[cell viewWithTag:6];
    
    UIImageView* hasPhotoImage = (UIImageView*)[cell viewWithTag:7];
    
    categoryLabel.text = itemGroup.categoryName;
    itemNameLabel.text = itemGroup.itemName;
    
    [itemGroup loadImageFromDisc];
    
    if(itemGroup.image != nil)
        [hasPhotoImage setHidden:NO];
    else
        [hasPhotoImage setHidden:YES];
    
    //Remove all other subviews from content view
    NSArray* subviews = [cell.contentView subviews];
    for(UIView* subview in subviews)
    {
        if(subview != categoryLabel && subview != itemNameLabel &&
           subview != qtyHeader && subview != conditionHeader &&
           subview != fmvHeader && subview != subtotalHeader &&
           subview != hasPhotoImage)
            [subview removeFromSuperview];
    }
    
    
    CGRect rowRect = CGRectMake(0, 66, 256, 15);
    NSArray* conditions = itemGroup.conditions;
    NSDictionary* summary = itemGroup.summary;

    for(int i = [conditionNames count] - 1; i >= 0; i--)
    {
        NSNumber* conditionNumber = [NSNumber numberWithInt:i];
        if([conditions containsObject:conditionNumber])
        {
            UIView* rowView = [[UIView alloc] initWithFrame:rowRect];

            UILabel* quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 23, 15)];
            quantityLabel.font = [UIFont systemFontOfSize:12];
            quantityLabel.text = [NSString stringWithFormat:@"%d",[[summary objectForKey:[NSString stringWithFormat:@"quantity_%d",i]] intValue]];

            UILabel* conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 65, 15)];
            conditionLabel.font = [UIFont systemFontOfSize:12];
            conditionLabel.text = [conditionNames objectAtIndex:i];
            conditionLabel.minimumFontSize = 10;

            UILabel* fmvLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 0, 96, 15)];
            fmvLabel.font = [UIFont systemFontOfSize:12];
            fmvLabel.text = [NSString stringWithFormat:@"$%.02f",[[summary objectForKey:[NSString stringWithFormat:@"fmv_%d",i]] doubleValue]];
            fmvLabel.textAlignment = NSTextAlignmentCenter;

            UILabel* subtotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(208, 0, 48, 15)];
            subtotalLabel.font = [UIFont systemFontOfSize:12];
            subtotalLabel.text = [NSString stringWithFormat:@"$%.02f",[[summary objectForKey:[NSString stringWithFormat:@"subtotal_%d",i]] doubleValue]];
            subtotalLabel.textAlignment = NSTextAlignmentRight;
            
            [rowView addSubview:quantityLabel];
            [rowView addSubview:conditionLabel];
            [rowView addSubview:fmvLabel];
            [rowView addSubview:subtotalLabel];
            
            [cell.contentView addSubview:rowView];
            
            rowRect.origin.y += 15;
        }
    }
    
    UIView* totalView = [[UIView alloc] initWithFrame:rowRect];
    
    UILabel* totalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 0, 96, 15)];
    totalTitleLabel.font = [UIFont boldSystemFontOfSize:12];
    totalTitleLabel.text = @"Total:";
    totalTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel* totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(208, 0, 48, 15)];
    totalLabel.font = [UIFont boldSystemFontOfSize:12];
    totalLabel.text = [NSString stringWithFormat:@"$%.02f",[[summary objectForKey:@"total"] doubleValue]];
    totalLabel.textAlignment = NSTextAlignmentRight;
    
    [totalView addSubview:totalTitleLabel];
    [totalView addSubview:totalLabel];
    
    [cell.contentView addSubview:totalView];
    
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
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Deleting" width:155];
        
        VPNItemGroup *groupToDelete = [itemGroups objectAtIndex:indexPath.row];
        groupToDelete.delegate = self;
        [groupToDelete deleteAllItems];
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

-(void) tableView:(UITableView *)localTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:localTableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    groupToEdit = [itemGroups objectAtIndex:indexPath.row];
    groupToEdit.isNew = NO;
    
    if(groupToEdit.categoryID == 0 && groupToEdit.itemID != 0)
    {
        Item* tempItem = [Item loadItemForID:groupToEdit.itemID];
        Category* tempCat = tempItem.category;
        
        groupToEdit.categoryID = [tempCat.categoryID intValue];
    }
    
    if(groupToEdit.isCustom)
        [self performSegueWithIdentifier:@"EditCustomItemSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"EditItemSegue" sender:self];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        [self performSegueWithIdentifier:@"PurchaseTaxYearSegue" sender:self];
    }
}

#pragma mark -
#pragma mark Custom Methods

-(IBAction) backPushed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)addCustomItemPushed:(id)sender {
    groupToEdit = [[VPNItemGroup alloc] init];
    groupToEdit.isCustom = YES;
    groupToEdit.isNew = YES;
    groupToEdit.donationList = self.donationList;
    
    [self performSegueWithIdentifier:@"EditCustomItemSegue" sender:self];
}

- (IBAction)addItemPushed:(id)sender {
    VPNUser* user = [VPNUser currentUser];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL instructionsShown = [[defaults objectForKey:@"ebay_instructions_shown"] boolValue];
    
    if(user.is_trial && !instructionsShown)
    {
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"ebay_instructions_shown"];
        [defaults synchronize];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"eBay® Values" message:@"You're on your way to greater tax savings using our eBay® database of Fair Market Values.  Our tax savings calculator estimates how much you're saving.  Try our eBay values up to $500 for FREE.  To keep using eBay values after that, you'll need to pay to upgrade." delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles: nil];
        [alert show];
    }
    
    double itemTotal = [VPNItemList ebayItemTotal];
    
    if((user.is_trial && itemTotal < 500.00) || !user.is_trial)
    {
        [self performSegueWithIdentifier:@"ItemSearchSegue" sender:self];
    }
    else if(user.is_trial && itemTotal >= 500.00)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Membership Upgrade" message:@"We've saved you over $125 in taxes now.  To save more and continue using our eBay® database of Fair Market Values you'll need to upgrade at the Apple Store." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade", nil];
        [alert show];
    }
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
    
    if([segue.destinationViewController respondsToSelector:@selector(setGroup:)])
    {
        [segue.destinationViewController setValue:groupToEdit forKey:@"group"];
    }
    
}


#pragma mark -
#pragma mark VPNEditCustomItemDelegate methods

-(void) itemGroupAdded:(VPNItemGroup*) addedGroup
{
    return;
    
    BOOL itemGroupFound = NO;
    if(addedGroup.isCustom)
    {
        for(VPNItemGroup* currentGroup in itemGroups)
        {
            if(currentGroup.isCustom && [currentGroup.itemName isEqualToString:addedGroup.itemName])
            {
                itemGroupFound = YES;
                
                NSMutableArray* newItems = addedGroup.items;
                NSMutableArray* currentItems = currentGroup.items;
                
                for(VPNItem* newItem in newItems)
                {
                    for(VPNItem* currentItem in currentItems)
                    {
                        if(newItem.condition == currentItem.condition)
                        {
                            currentItem.quantity += newItem.quantity;
                        }
                    }
                }
                
                [currentGroup buildItemSummary];
            }
        }
    }
    else
    {
        for(VPNItemGroup* currentGroup in itemGroups)
        {
            if(!currentGroup.isCustom && currentGroup.itemID == addedGroup.itemID)
            {
                itemGroupFound = YES;
                
                NSMutableArray* newItems = addedGroup.items;
                NSMutableArray* currentItems = currentGroup.items;
                
                for(VPNItem* newItem in newItems)
                {
                    for(VPNItem* currentItem in currentItems)
                    {
                        if(newItem.condition == currentItem.condition)
                        {
                            currentItem.quantity += newItem.quantity;
                        }
                    }
                }
                
                [currentGroup buildItemSummary];
            }
        }        
    }
    
    if(!itemGroupFound)
        [itemGroups addObject:addedGroup];
    
    [self.tableView reloadData];
}

-(void) itemGroupUpdated:(VPNItemGroup*) updatedGroup
{
    return;
    
    VPNItemGroup* groupToReplace = nil;
    
    for(VPNItemGroup* currentGroup in itemGroups)
    {
        if(updatedGroup.isCustom)
        {
            if([updatedGroup.itemName isEqualToString:currentGroup.itemName] && currentGroup.isCustom)
            {
                groupToReplace = currentGroup;
                break;
            }
        }
        else
        {
            if(!currentGroup.isCustom && updatedGroup.itemID == currentGroup.itemID)
            {
                groupToReplace = currentGroup;
                break;
            }
        }
    }
    
    [updatedGroup buildItemSummary];
    if(groupToReplace == nil)
    {
        [itemGroups addObject:updatedGroup];
    }
    else
    {
        int index = [itemGroups indexOfObject:groupToReplace];
        [itemGroups replaceObjectAtIndex:index withObject:updatedGroup];
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark VPNItemGroupDelegate

-(void) didFinishSavingItemGroup
{
    VPNUser* currentUser = [VPNUser currentUser];
    [DejalBezelActivityView currentActivityView].activityLabel.text = @"Updating Item Lists";
    
    [manager getItemListsForTaxYear:currentUser.selected_tax_year forceDownload:YES];
}

-(void) saveFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"Unable to save your items at this time, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alert show];
    
}

#pragma mark -
#pragma mark VPNCDManagerDelegate methods

-(void) didGetItemLists:(NSArray *)itemLists
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [self refreshItemGroups];
}

-(void) getItemListsFailedWithError:(NSError *)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Update Error" message:@"Unable to update your items at this time, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alert show];
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
    [self setAddCustomItemButton:nil];
    [self setAddEbayItemButton:nil];
    [super viewDidUnload];
}

-(void) dismissEditCustomItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
