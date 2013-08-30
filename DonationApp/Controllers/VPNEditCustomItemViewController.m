//
//  VPNEditCustomItemViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/19/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "VPNEditCustomItemViewController.h"
#import "VPNModalPickerView.h"
#import "VPNItemList.h"
#import "Category.h"

#import "DejalActivityView.h"

static CGFloat keyboardHeight = 216;
static CGFloat toolbarHeight = 44;
static CGFloat tabBarHeight = 49;

static CGFloat warningLimit = 5000.00;
static CGFloat itemListLimit = 15000.00;

@interface VPNEditCustomItemViewController ()
{
    VPNModalPickerView* modalPicker;
    VPNCDManager* manager;
    NSArray* categories;
    
    UITextField* currentTextField;
    
    UIImagePickerController* imageController;
    
    UINavigationController* origNavigationController;
}
@end

@implementation VPNEditCustomItemViewController

@synthesize customItemCellNib;
@synthesize itemNameCellNib;
@synthesize doneToolbarNib;

@synthesize group;
@synthesize tableView;
@synthesize doneButton;
@synthesize doneToolbar;

@synthesize delegate;

-(UINib*) customItemCellNib
{
    if(customItemCellNib == nil)
    {
        self.customItemCellNib = [VPNCustomItemConditionCell nib];
    }
    
    return customItemCellNib;
}

-(UINib*) itemNameCellNib
{
    if(itemNameCellNib == nil)
    {
        self.itemNameCellNib = [VPNItemNameCell nib];
    }
    
    return itemNameCellNib;
}

-(UINib*) doneToolbarNib
{
    if(doneToolbarNib == nil)
    {
        self.doneToolbarNib = [VPNDoneToolbar nib];
    }
    
    return doneToolbarNib;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    imageController = [[UIImagePickerController alloc] init];
    imageController.delegate = self;
    imageController.allowsEditing = YES;
    
    
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    modalPicker = [[VPNModalPickerView alloc] initWithNibName:[VPNModalPickerView nibName]];
    categories = [Category loadCategoriesForCategoryID:0];
    
    modalPicker.options = categories;
    modalPicker.delegate = self;
    
    doneToolbar = [VPNDoneToolbar doneToolbarFromFromNib:[VPNDoneToolbar nib]];
    doneToolbar.delegate = self;
    
    [group loadImageFromDisc];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [modalPicker addToView:self.view];
    [self updateDoneButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

-(void) replaceTextField:(UITextField*)textField inCell:(UITableViewCell*)cell forTag:(int)tag
{
    UITextField* cellField = (UITextField*)[cell viewWithTag:tag];
    textField.frame = cellField.frame;
    
    [cellField removeFromSuperview];
    [cell.contentView addSubview:textField];
}

-(UITableViewCell*) tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"VPNCustomItemConditionCell";
    UITableViewCell* cell = nil;
    
    if(indexPath.section == 0 && indexPath.row == 0)
        CellIdentifier = @"CategoryCell";
    else if(indexPath.section == 0 && indexPath.row == 1)
        CellIdentifier = @"VPNItemNameCell";
    else if(indexPath.section == 1 && indexPath.row == 0)
        CellIdentifier = @"ColumnHeaderCell";
    else if(indexPath.section == 1 && indexPath.row == 6)
        CellIdentifier = @"PhotoCell";
    
    
    if(![CellIdentifier isEqualToString:@"VPNCustomItemConditionCell"] && ![CellIdentifier isEqualToString:@"VPNItemNameCell"])
    {
        cell = [localTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if([CellIdentifier isEqualToString:@"CategoryCell"])
        {
            UILabel* categoryLabel = (UILabel*)[cell viewWithTag:1];
            
            if(nil == group.categoryName || [group.categoryName isEqualToString:@""])
                categoryLabel.text = @"Please Choose";
            else
                categoryLabel.text = group.categoryName;
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
    else if([CellIdentifier isEqualToString:@"VPNItemNameCell"])
    {
        VPNItemNameCell *itemNameCell = [VPNItemNameCell cellForTableView:localTableView fromNib:self.itemNameCellNib];
        
        itemNameCell.delegate = self;
        
        itemNameCell.indexPath = indexPath;
        itemNameCell.textLabel.text = group.itemName;
        
        return itemNameCell;
        
    }
    else if([CellIdentifier isEqualToString:@"VPNCustomItemConditionCell"])
    {
        VPNCustomItemConditionCell *conditionCell = [VPNCustomItemConditionCell cellForTableView:localTableView fromNib:self.customItemCellNib];
        
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

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    else
        return 7;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row != 6)
        return NO;
    
    if(indexPath.section == 0 && indexPath.row == 1)
        return NO;
    
    return YES;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        for(int i = 0; i < [categories count]; i++)
        {
            Category* currentCategory = (Category*)[categories objectAtIndex:i];
            
            if([currentCategory.name isEqualToString:group.categoryName])
            {
                modalPicker.selectedIndex = i;
            }
        }
        
        [modalPicker show];
    }
    else if(indexPath.section == 1 && indexPath.row == 6)
    {
        if(group.image == nil)
        {
            UIActionSheet* imageSourceSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
            
            [imageSourceSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else
        {
            [self performSegueWithIdentifier:@"CustomItemViewPhotoSegue" sender:self];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    imageController.sourceType = sourceType;

    [self.tabBarController presentViewController:imageController animated:YES completion:^{}];
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
    [self.tabBarController dismissViewControllerAnimated:YES completion:^{}];
    
    [self.tabBarController setSelectedIndex:3];
    [self.tabBarController setSelectedIndex:2];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.tabBarController dismissViewControllerAnimated:YES completion:^{}];
    
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
    
    [self updateDoneButton];
}

-(void) fmvUpdated:(double)fmv atIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"Updating Value: %.02f for row %d",fmv,indexPath.row);
    switch(indexPath.row)
    {
        case 1: [group setValue:fmv forCondition:Mint]; break;
        case 2: [group setValue:fmv forCondition:Excellent]; break;
        case 3: [group setValue:fmv forCondition:VeryGood]; break;
        case 4: [group setValue:fmv forCondition:Good]; break;
        case 5: [group setValue:fmv forCondition:Fair]; break;
        default: break;
    }
    
    [self updateDoneButton];
}



-(void) quantityField:(UITextField*)quantityField focusedAtIndexPath:(NSIndexPath*)indexPath
{
    [self shrinkTable];
    [doneButton setEnabled:NO];
    
    quantityField.inputAccessoryView = doneToolbar;
    currentTextField = quantityField;

    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void) fmvField:(UITextField*)fmvField focusedAtIndexPath:(NSIndexPath*)indexPath
{
    [self shrinkTable];
    [doneButton setEnabled:NO];
    
    fmvField.inputAccessoryView = doneToolbar;
    currentTextField = fmvField;
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}


#pragma mark -
#pragma mark VPNModalPickerViewDelegate

-(void) optionWasSelectedAtIndex:(int)selectedIndex
{
    Category* localCategory = [categories objectAtIndex:selectedIndex];
    group.categoryName = localCategory.name;
    group.categoryID = [localCategory.categoryID intValue];
    
    NSLog(@"Category Name: %@",group.categoryName);
}

-(void) pickerWasDismissed
{
    NSLog(@"Picker dismissed");
    [doneButton setEnabled:YES];
    if(group.categoryName == nil || [group.categoryName isEqualToString:@""])
    {
        Category* localCategory = [categories objectAtIndex:0];
        group.categoryName = localCategory.name;
    }
    
    [self updateDoneButton];
    [self.tableView reloadData];
}

-(void) pickerWasDisplayed
{
    [doneButton setEnabled:NO];
    NSLog(@"Picker displayed");
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
}

#pragma mark -
#pragma mark VPNDoneToolbarDelegate Methods

-(void) doneToolbarButtonPushed:(id)sender
{
    [self expandTable];
    [doneButton setEnabled:YES];
    
    if(currentTextField != nil)
    {
        [currentTextField resignFirstResponder];
        currentTextField = nil;
    }
}

#pragma mark -
#pragma mark VPNItemNameCellDelegate Methods

-(void) itemNameFieldUpdatedWithText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
{
    group.itemName = text;
    [self updateDoneButton];
}

-(void) itemNameField:(UITextField *)itemNameField focusedAtIndexPath:(NSIndexPath *)indexPath
{
    [self shrinkTable];
    itemNameField.inputAccessoryView = doneToolbar;
    currentTextField = itemNameField;
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

    [delegate dismissEditCustomItem];
    
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void) getItemListsFailedWithError:(NSError *)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Update Error" message:@"Unable to update your items at this time, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alert show];
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
        [self presentViewController:mailController animated:YES completion:^{}];
    }
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Methods
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark -
#pragma mark Custom Methods

-(void) updateDoneButton
{
    NSMutableArray* errors;
    if([self isGroupValid:&errors])
    {
        [doneButton setTintColor:[UIColor blueColor]];
    }
    else
    {
        [doneButton setTintColor:nil];
    }
}


-(BOOL) isGroupValid:(NSMutableArray**) errors
{
    BOOL isValid = YES;
    
    if(group.categoryID == 0)
    {
        isValid = NO;
        [*errors addObject:@"Please select a category.\r\n"];
    }
    
    if(group.itemName == nil || [group.itemName length] == 0)
    {
        isValid = NO;
        [*errors addObject:@"Please set an item name.\r\n"];
    }
    
    if([group totalQuantityForAllConditons] == 0)
    {
        isValid = NO;
        [*errors addObject:@"One item must have a quantity.\r\n"];
    }
    
    if([group totalValueForAllConditions] == 0.00)
    {
        isValid = NO;
        [*errors addObject:@"One item must have a value.\r\n"];
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
