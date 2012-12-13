//
//  VPNAddDonationListViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/10/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNAddDonationListViewController.h"
#import "VPNCDManager.h"
#import "VPNItemList.h"
#import "VPNCashList.h"
#import "VPNMileageList.h"
#import "VPNUser.h"

@interface VPNAddDonationListViewController ()
{
    BOOL datePickerDisplayed;
    BOOL organizationPickerDisplayed;
    BOOL itemSourcePickerDisplayed;
    
    NSArray* organizations;
    NSArray* itemSources;
    
    UITextField* currentField;
    
    id submittingButton;
    
    VPNCDManager* manager;
}

@end

@implementation VPNAddDonationListViewController

@synthesize listTable;

@synthesize datePickerView;
@synthesize organizationPickerView;
@synthesize itemSourcePickerView;

@synthesize datePicker;
@synthesize organizationPicker;
@synthesize itemSourcePicker;

@synthesize selectedListType;

@synthesize donationList;
@synthesize organization;

@synthesize keyboardToolbar;
@synthesize startAddingItemsButton;
@synthesize doneButton;

@synthesize notesField;

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
    
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    [[NSBundle mainBundle] loadNibNamed:@"KeyboardDoneToolbarView" owner:self options:nil];
    
    organizations = [VPNOrganization loadOrganizationsFromDisc];
    itemSources = @[@"I purchased them.",@"They were a gift.",@"I inherited them.",@"I made an exchange"];

    VPNUser* user = [VPNUser currentUser];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //Shift date to current year for default value
    [dateFormat setDateFormat:@"MMdd"];
    NSString* currentDay = [dateFormat stringFromDate:[NSDate date]];
    
    NSString* taxYearFormat = [NSString stringWithFormat:@"%d%@",user.selected_tax_year,currentDay];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
	// Do any additional setup after loading the view.
    donationList = [[VPNDonationList alloc] init];
    donationList.listType = 0;
    donationList.name = @"";
    donationList.donationDate = [dateFormat dateFromString:taxYearFormat];
    donationList.creationDate = [NSDate date];
    donationList.howAquired = [itemSources objectAtIndex:0];
    
    selectedListType = 0;
    
    [datePicker addTarget:self
                     action:@selector(updateListDate:)
           forControlEvents:UIControlEventValueChanged];
    
    NSString* minDate = [NSString stringWithFormat:@"%d0101",user.selected_tax_year];
    NSString* maxDate = [NSString stringWithFormat:@"%d1231",user.selected_tax_year];
    
    datePicker.minimumDate = [dateFormat dateFromString:minDate];
    datePicker.maximumDate = [dateFormat dateFromString:maxDate];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
 
    organizationPicker.dataSource = self;
    organizationPicker.delegate = self;
    
    itemSourcePicker.dataSource = self;
    itemSourcePicker.delegate = self;
    
    //Add picker views to frame
    CGRect mainFrame = self.view.frame;
    CGRect pickerFrame = CGRectMake(0, mainFrame.size.height, 320, mainFrame.size.height);
    
    datePickerView.frame = pickerFrame;
    organizationPickerView.frame = pickerFrame;
    itemSourcePickerView.frame = pickerFrame;
    
    [self.view addSubview:datePickerView];
    [self.view addSubview:organizationPickerView];
    [self.view addSubview:itemSourcePickerView];
    
    [self.view bringSubviewToFront:datePickerView];
    [self.view bringSubviewToFront:organizationPickerView];
    [self.view bringSubviewToFront:itemSourcePickerView];
    
    self.listTable.scrollEnabled = NO;
    
    doneButton.enabled = NO;
    startAddingItemsButton.enabled = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case 0:
        case 1:
        case 2:
            return 44;
        case 3:
            if(selectedListType == 0)
                return 62;
            else if(selectedListType == 1 || selectedListType == 2)
                return 75;
        default: break;
    }

    return 1000;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"Cell";
    switch(indexPath.row)
    {
        case 0: CellIdentifier = @"DonationDateCell"; break;
        case 1: CellIdentifier = @"OrganizationCell"; break;
        case 2: CellIdentifier = @"ListTypeCell"; break;
        case 3:
            if(selectedListType == 0)
                CellIdentifier = @"ItemSourceCell";
            else if(selectedListType == 1)
                CellIdentifier = @"CashAmountCell";
            else if(selectedListType == 2)
                CellIdentifier = @"MileageAmountCell";
            
            break;
        default: break;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([CellIdentifier isEqualToString:@"DonationDateCell"])
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        
        UILabel* dateLabel = (UILabel*)[cell viewWithTag:1];
        dateLabel.text = [formatter stringFromDate:self.donationList.donationDate];
    }
    else if([CellIdentifier isEqualToString:@"OrganizationCell"])
    {
        UILabel* organizationLabel = (UILabel*)[cell viewWithTag:1];
        
        if(self.organization == nil)
            organizationLabel.text = @"Please Choose";
        else
            organizationLabel.text = self.organization.name;
    }
    else if([CellIdentifier isEqualToString:@"ListTypeCell"])
    {
        UISegmentedControl* listSelector = (UISegmentedControl*)[cell viewWithTag:1];
        [listSelector addTarget:self
                             action:@selector(updateListType:)
                   forControlEvents:UIControlEventValueChanged];
        [listSelector setSelectedSegmentIndex:selectedListType];
    }
    else if([CellIdentifier isEqualToString:@"ItemSourceCell"])
    {
        UILabel* itemSource = (UILabel*)[cell viewWithTag:1];
        
        VPNItemList* itemList = (VPNItemList*)self.donationList;
        itemSource.text = itemList.howAquired;
    }
    else if([CellIdentifier isEqualToString:@"CashAmountCell"])
    {
        UITextField* cashAmountField = (UITextField*)[cell viewWithTag:1];
        cashAmountField.delegate = self;
        
        VPNCashList* cashList = (VPNCashList*)self.donationList;
        cashAmountField.text = [cashList.cashDonation stringValue];
    }
    else if([CellIdentifier isEqualToString:@"MileageAmountCell"])
    {
        UITextField* mileageAmountField = (UITextField*)[cell viewWithTag:1];
        mileageAmountField.delegate = self;
        
        VPNMileageList* mileageList = (VPNMileageList*)self.donationList;
        mileageAmountField.text = [mileageList.mileage stringValue];
    }
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(indexPath.row)
    {
        case 0:
            [self displayDatePicker];
            break;
        case 1:
            if(organization == nil)
            {
                organization = [organizations objectAtIndex:0];
                [self.listTable reloadData];
                
                startAddingItemsButton.enabled = YES;
                doneButton.enabled = YES;
            }
            
            [self displayOrganizationPicker];
            break;
        case 3:
            if(selectedListType == 0)
                [self displayItemSourcePicker];
            
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIPickerViewDelegate Methods

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == organizationPicker)
    {
        VPNOrganization* currentOrg = [organizations objectAtIndex:row];
        return currentOrg.name;
    }
    else if(pickerView == itemSourcePicker)
    {
        return [itemSources objectAtIndex:row];
    }
    
    return @"";
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == organizationPicker)
    {
        organization = [organizations objectAtIndex:row];
        donationList.companyID = organization.ID;
    }
    else if(pickerView == itemSourcePicker)
    {
        donationList.howAquired = [itemSources objectAtIndex:row];
    }
    
    [self.listTable reloadData];
}

#pragma mark -
#pragma mark UIPickerViewDataSource Methods

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == organizationPicker)
    {
        return [organizations count];
    }
    else if(pickerView == itemSourcePicker)
    {
        return [itemSources count];
    }

    return 0;
}


#pragma mark -
#pragma mark Custom Methods

-(IBAction) datePickerDonePushed:(id)sender
{
    [self hideDatePicker];
}

-(IBAction) organizationPickerDonePushed:(id)sender
{
    [self hideOrganizationPicker];
}

-(IBAction) itemSourcePickerDonePushed:(id)sender
{
    [self hideItemSourcePicker];
}

-(void) displayDatePicker
{
    [self keyboardDone:nil];    
    
    if(organizationPickerDisplayed)
        [self hideOrganizationPicker];
    
    if(itemSourcePickerDisplayed)
        [self hideItemSourcePicker];
    
    //Show filter picker view
    if(!datePickerDisplayed)
    {
        datePickerDisplayed = YES;
        datePicker.date = donationList.donationDate;
        [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect frame = self.datePickerView.frame;
            frame.origin.y -= (frame.size.height+93);
            
            self.datePickerView.frame = frame;
        }
                         completion:nil];
    }
}

-(void) hideDatePicker
{
    if(datePickerDisplayed)
    {
        datePickerDisplayed = NO;
        [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect frame = self.datePickerView.frame;
            frame.origin.y += (frame.size.height+93);
            
            self.datePickerView.frame = frame;
        }
                         completion:nil];
    }
}


-(void) displayOrganizationPicker
{
    [self keyboardDone:nil];    
    
    if(datePickerDisplayed)
        [self hideDatePicker];
    
    if(itemSourcePickerDisplayed)
        [self hideItemSourcePicker];
    
    //Show filter picker view
    if(!organizationPickerDisplayed)
    {
        organizationPickerDisplayed = YES;
        [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect frame = self.organizationPickerView.frame;
            frame.origin.y -= (frame.size.height+93);
            
            self.organizationPickerView.frame = frame;
        }
                         completion:nil];
    }
}

-(void) hideOrganizationPicker
{
    //Show filter picker view
    if(organizationPickerDisplayed)
    {
        organizationPickerDisplayed = NO;
        [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect frame = self.organizationPickerView.frame;
            frame.origin.y += (frame.size.height+93);
            
            self.organizationPickerView.frame = frame;
        }
                         completion:nil];
    }
}

-(void) displayItemSourcePicker
{
    [self keyboardDone:nil];
    
    if(datePickerDisplayed)
        [self hideDatePicker];
    
    if(organizationPickerDisplayed)
        [self hideOrganizationPicker];
    
    //Show filter picker view
    if(!itemSourcePickerDisplayed)
    {
        itemSourcePickerDisplayed = YES;
        [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect frame = self.itemSourcePickerView.frame;
            frame.origin.y -= (frame.size.height+93);
            
            self.itemSourcePickerView.frame = frame;
        }
                         completion:nil];
    }
}

-(void) hideItemSourcePicker
{
    //Show filter picker view
    if(itemSourcePickerDisplayed)
    {
        itemSourcePickerDisplayed = NO;
        [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect frame = self.itemSourcePickerView.frame;
            frame.origin.y += (frame.size.height+93);
            
            self.itemSourcePickerView.frame = frame;
        }
                         completion:nil];
    }
}

-(void) updateListType:(UISegmentedControl*)segmentedControl
{
    selectedListType = (int)segmentedControl.selectedSegmentIndex;
    
    if(selectedListType == 0)
        [self.startAddingItemsButton setHidden:NO];
    else
        [self.startAddingItemsButton setHidden:YES];
    
    [self.listTable reloadData];
}

-(void) updateListDate:(UIDatePicker*)localDatePicker
{
    donationList.donationDate = [localDatePicker.date copy];
    [self.listTable reloadData];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    //Scroll table view up
    NSIndexPath* fieldRow = [NSIndexPath indexPathForRow:3 inSection:0];

    self.listTable.scrollEnabled = YES;
    [self.listTable scrollToRowAtIndexPath:fieldRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.listTable.scrollEnabled = NO;
    
    currentField = textField;
    [currentField setInputAccessoryView:self.keyboardToolbar];
}

-(IBAction) keyboardDone:(id)sender
{
    //Scroll table view down
    NSIndexPath* fieldRow = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.listTable.scrollEnabled = YES;
    [self.listTable scrollToRowAtIndexPath:fieldRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.listTable.scrollEnabled = NO;
    
    if(currentField != nil)
    {
        if(selectedListType == 1)
            donationList.cashDonation = [NSNumber numberWithDouble:[currentField.text doubleValue]];
        else if(selectedListType == 2)
            donationList.mileage = [NSNumber numberWithDouble:[currentField.text doubleValue]];
        
        [currentField resignFirstResponder];
    }
}

-(IBAction) donePushed:(id)sender
{
    submittingButton = sender;
    donationList.listType = selectedListType;
    donationList.notes = notesField.text;
    donationList.costBasis = [NSNumber numberWithInt:0];

    if(organization == nil)
        organization = [organizations objectAtIndex:0];
    
    donationList.companyID = organization.ID;
    donationList.name = organization.name;
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //Shift date to current year for default value
    [dateFormat setDateFormat:@"MM/dd/YYYY"];
    donationList.dateAquired = [dateFormat stringFromDate:donationList.donationDate];

    
    [manager addDonationList:donationList];
}

-(IBAction) startAddingItemsPushed:(id)sender
{
    [self donePushed:sender];
}

-(IBAction) finishedEditingItems:(UIStoryboardSegue*)segue
{
    //Should have poped to this controller;
}

#pragma mark -
#pragma mark VPNCDManagerDelegate methods

-(void) didAddList:(VPNDonationList*)list
{
    VPNUser* user = [VPNUser currentUser];
    
    if(list.listType == 0)
    {
        NSMutableArray* itemLists = [VPNItemList loadItemListsFromDisc:user.selected_tax_year];
        [itemLists addObject:list];
        [VPNItemList saveItemListsToDisc:itemLists forTaxYear:user.selected_tax_year];
    }
    else if(list.listType == 1)
    {
        NSMutableArray* cashLists = [VPNCashList loadCashListsFromDisc:user.selected_tax_year];
        [cashLists addObject:list];
        [VPNCashList saveCashListsToDisc:cashLists forTaxYear:user.selected_tax_year];
    }
    else if(list.listType == 2)
    {
        NSMutableArray* mileageLists = [VPNMileageList loadMileageListsFromDisc:user.selected_tax_year];
        [mileageLists addObject:list];
        [VPNMileageList saveMileageListsToDisc:mileageLists forTaxYear:user.selected_tax_year];
    }
    
    if(submittingButton == doneButton)
        [self.navigationController popViewControllerAnimated:YES];
    else if(submittingButton == startAddingItemsButton)
        [self performSegueWithIdentifier:@"ItemListSegue" sender:submittingButton];
}

-(void) addListFailedWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Add List Error" message:@"Unable to add your donation list at this time, please try again later" delegate:nil cancelButtonTitle:@"close" otherButtonTitles: nil];
    
    [alert show];
}

@end
