//
//  VPNEditItemViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/28/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNEditItemViewController.h"
#import "DejalActivityView.h"
#import "VPNDonationItemListViewController.h"
#import "VPNItemList.h"
#import "Category.h"

static CGFloat keyboardHeight = 216;
static CGFloat toolbarHeight = 44;
static CGFloat tabBarHeight = 49;

static CGFloat warningLimit = 5000.00;
static CGFloat itemListLimit = 15000.00;

@interface VPNEditItemViewController ()
{
    VPNCDManager* manager;
    UITextField* currentTextField; 
}


@end

@implementation VPNEditItemViewController

@synthesize itemCellNib;
@synthesize doneToolbarNib;

@synthesize group;
@synthesize doneButton;
@synthesize doneToolbar;

@synthesize tableView;

-(UINib*) itemCellNib
{
    if(itemCellNib == nil)
    {
        self.itemCellNib = [VPNItemConditionCell nib];
    }
    
    return itemCellNib;
}

-(UINib*) doneToolbarNib
{
    if(doneToolbarNib == nil)
    {
        self.doneToolbarNib = [VPNDoneToolbar nib];
    }
    
    return doneToolbarNib;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    doneToolbar = [VPNDoneToolbar doneToolbarFromFromNib:[VPNDoneToolbar nib]];
    doneToolbar.delegate = self;
    
    [group loadImageFromDisc];    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    else
        return 7;
}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"VPNItemConditionCell";
    UITableViewCell* cell = nil;
    
    if(indexPath.section == 0 && indexPath.row == 0)
        CellIdentifier = @"CategoryCell";
    else if(indexPath.section == 0 && indexPath.row == 1)
        CellIdentifier = @"ItemCell";
    else if(indexPath.section == 1 && indexPath.row == 0)
        CellIdentifier = @"ColumnHeaderCell";
    else if(indexPath.section == 1 && indexPath.row == 6)
        CellIdentifier = @"PhotoCell";
    
    
    if(![CellIdentifier isEqualToString:@"VPNItemConditionCell"])
    {
        cell = [localTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if([CellIdentifier isEqualToString:@"CategoryCell"])
        {
            UILabel* categoryLabel = (UILabel*)[cell viewWithTag:1];
            categoryLabel.text = group.categoryName;
        }
        else if([CellIdentifier isEqualToString:@"ItemCell"])
        {
            UILabel* itemLabel = (UILabel*)[cell viewWithTag:1];
            itemLabel.text = group.itemName;
        }
        else if([CellIdentifier isEqualToString:@"PhotoCell"])
        {
            GradientButton* photoButton = (GradientButton*)[cell viewWithTag:1];
            [photoButton useGreenConfirmStyle];
            
            if(group.image == nil)
                [photoButton setHidden:YES];
            else
                [photoButton setHidden:NO];
        }
    }
    else if([CellIdentifier isEqualToString:@"VPNItemConditionCell"])
    {
        VPNItemConditionCell *conditionCell = [VPNItemConditionCell cellForTableView:localTableView fromNib:self.itemCellNib];
        
        conditionCell.delegate = self;
        
        conditionCell.indexPath = indexPath;
        
        switch(indexPath.row)
        {
            case 1: //Mint
                [conditionCell setQuantity:[group quantityForCondition:Mint]];
                [conditionCell setFMV:[group valueForCondition:Mint]];
                [conditionCell setConditionText:@"Mint/New"];
                break;
            case 2: //Excellent
                [conditionCell setQuantity:[group quantityForCondition:Excellent]];
                [conditionCell setFMV:[group valueForCondition:Excellent]];
                [conditionCell setConditionText:@"Excellent"];
                break;
            case 3: //Very Good
                [conditionCell setQuantity:[group quantityForCondition:VeryGood]];
                [conditionCell setFMV:[group valueForCondition:VeryGood]];
                [conditionCell setConditionText:@"Very Good"];
                break;
            case 4: //Good
                [conditionCell setQuantity:[group quantityForCondition:Good]];
                [conditionCell setFMV:[group valueForCondition:Good]];
                [conditionCell setConditionText:@"Good"];
                break;
            case 5: //Fair
                [conditionCell setQuantity:[group quantityForCondition:Fair]];
                [conditionCell setFMV:[group valueForCondition:Fair]];
                [conditionCell setConditionText:@"Fair or Less"];
                break;
            default:
                break;
        }
        
        return conditionCell;
    }
    
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 6)
        return YES;
    
    return NO;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 6)
    {
        if(group.image == nil)
        {
            UIActionSheet* imageSourceSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
            
            [imageSourceSheet showInView:self.view];
        }
        else
        {
            [self performSegueWithIdentifier:@"ItemViewPhotoSegue" sender:self];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
        [mailController setToRecipients:@[@"support@charitydeductions.com"]];
        [mailController setSubject:@"Donation Limit Support Request"];
        
        mailController.mailComposeDelegate = self;
        [self presentModalViewController:mailController animated:YES];
    }
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Methods
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIActionSheetDelegate method

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 2)
        return;
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if(buttonIndex == 1)
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIImagePickerController* imageController = [[UIImagePickerController alloc] init];
    imageController.sourceType = sourceType;
    imageController.delegate = self;
    imageController.allowsEditing = YES;
    
    [self presentViewController:imageController animated:YES completion:^{}];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    group.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(group.image == nil)
    {
        group.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    [self.tabBarController setSelectedIndex:3];
    [self.tabBarController setSelectedIndex:2];

}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    [self.tabBarController setSelectedIndex:3];
    [self.tabBarController setSelectedIndex:2];
}

#pragma mark -
#pragma mark VPNViewPhotoDelegate methods

-(void) viewPhotoViewControllerDeletedPhoto
{
    group.image = nil;
    [self.tableView reloadData];
}

-(void) viewPhotoViewControllerUpdatedPhoto:(UIImage *)updatedImage
{
    group.image = updatedImage;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Segue Methods

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destController = segue.destinationViewController;
    if([destController respondsToSelector:@selector(setImage:)])
    {
        [destController setValue:group.image forKey:@"image"];
    }
    
    if([destController respondsToSelector:@selector(setDelegate:)])
    {
        [destController setValue:self forKey:@"delegate"];
    }
}


#pragma mark -
#pragma mark VPNCustomItemConditionCellDelegate Methods

-(void) quantityUpdated:(int)quantity atIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"Updating Quantity: %d for row %d",quantity,indexPath.row);
    switch(indexPath.row)
    {
        case 1: [group setQuantity:quantity forCondition:Mint]; break;
        case 2: [group setQuantity:quantity forCondition:Excellent]; break;
        case 3: [group setQuantity:quantity forCondition:VeryGood]; break;
        case 4: [group setQuantity:quantity forCondition:Good]; break;
        case 5: [group setQuantity:quantity forCondition:Fair]; break;
        default: break;
    }
}

-(void) quantityField:(UITextField*)quantityField focusedAtIndexPath:(NSIndexPath*)indexPath
{
    [self shrinkTable];
    
    quantityField.inputAccessoryView = doneToolbar;
    currentTextField = quantityField;
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -
#pragma mark VPNDoneToolbarDelegate Methods

-(void) doneToolbarButtonPushed:(id)sender
{
    [self expandTable];
    
    if(currentTextField != nil)
    {
        [currentTextField resignFirstResponder];
        currentTextField = nil;
    }
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
    
    NSArray* controllers = self.navigationController.viewControllers;
    UIViewController* destController = nil;
    
    for(UIViewController* currentController in controllers)
    {
        if([currentController isKindOfClass:[VPNDonationItemListViewController class]])
        {
            destController = currentController;
            break;
        }
    }
    
    if(destController != nil)
    {
        [self.navigationController popToViewController:destController animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) getItemListsFailedWithError:(NSError *)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Update Error" message:@"Unable to update your items at this time, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alert show];
}

#pragma mark -
#pragma mark Custom Methods

-(BOOL) isGroupValid:(NSMutableArray**) errors
{
    BOOL isValid = YES;
    
    if([group totalQuantityForAllConditons] == 0)
    {
        isValid = NO;
        [*errors addObject:@"One item must have a quantity.\r\n"];
    }
    
    return isValid;
}

-(IBAction) doneButtonPushed:(id)sender
{
    NSMutableArray* errorMessages = [[NSMutableArray alloc] init];
    if([self isGroupValid:&errorMessages])
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        BOOL warningDisplayed = [[defaults objectForKey:@"appraisal_warning_displayed"] boolValue];
        
        double groupTotal = [group totalValueForAllConditions];
        
        if(!warningDisplayed && groupTotal > warningLimit)
        {
            [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"appraisal_warning_displayed"];
            [defaults synchronize];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Appraisal Warning" message:@"The IRS requires a qualified appraisal for an item or group of similar items valued above $5000. This app won't qualify. See IRS Pub 561" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
        VPNUser* user = [VPNUser currentUser];
        NSArray* itemLists = [VPNItemList loadItemListsFromDisc:user.selected_tax_year];
        double totalForLists = 0.00;
        for(VPNItemList* itemList in itemLists)
        {
            totalForLists += [itemList totalForItems];
        }
        
        if((totalForLists + groupTotal) >= itemListLimit)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Max Donations Reached" message:@"There is a maximum item donation amount of $15,000.  Saving this donation would exceed this limit.  Please make the necessary adjustments and try again." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Contact Us", nil];
            [alert show];
        }
        else
        {
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Saving" width:155];
            group.delegate = self;
            [group save];
        }
    }
    else
    {
        NSString* error = @"The following errors occured:\r\n";
        for(NSString* currentError in errorMessages)
        {
            error = [error stringByAppendingString:currentError];
        }
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Item" message:error delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    }
}

-(void) expandTable
{
    CGRect tableFrame = self.tableView.frame;
    if(tableFrame.size.height >= 367)
        return;
    
    tableFrame.size.height += (keyboardHeight + toolbarHeight - tabBarHeight);
    self.tableView.frame = tableFrame;
}

-(void) shrinkTable
{
    CGRect tableFrame = self.tableView.frame;
    if(tableFrame.size.height < 367)
        return;
    
    tableFrame.size.height -= (keyboardHeight + toolbarHeight - tabBarHeight);
    self.tableView.frame = tableFrame;
}


@end
