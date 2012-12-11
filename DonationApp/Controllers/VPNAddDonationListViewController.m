//
//  VPNAddDonationListViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/10/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNAddDonationListViewController.h"
#import "VPNItemList.h"
#import "VPNCashList.h"
#import "VPNMileageList.h"

@interface VPNAddDonationListViewController ()
{
    BOOL datePickerDisplayed;
    BOOL organizationPickerDisplayed;
    BOOL itemSourcePickerDisplayed;
}

@end

@implementation VPNAddDonationListViewController
@synthesize listTable;
@synthesize listTypeSelector;
@synthesize donationList;

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
	// Do any additional setup after loading the view.
    donationList = [[VPNDonationList alloc] init];
    donationList.listType = 0;
    donationList.donationDate = [NSDate date];
    donationList.creationDate = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"Cell";
    switch(indexPath.row)
    {
        case 0: CellIdentifier = @"DonationDateCell"; break;
        case 1: CellIdentifier = @"OrganizationCell"; break;
        case 2: CellIdentifier = @"ListTypeCell"; break;
        case 3:
            if(listTypeSelector.selectedSegmentIndex == 0)
                CellIdentifier = @"ItemSourceCell";
            else if(listTypeSelector.selectedSegmentIndex == 1)
                CellIdentifier = @"CashAmountCell";
            else if(listTypeSelector.selectedSegmentIndex == 2)
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
        [listSelector setSelectedSegmentIndex:self.donationList.listType];
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
        
        VPNCashList* cashList = (VPNCashList*)self.donationList;
        cashAmountField.text = [cashList.cashDonation stringValue];
    }
    else if([CellIdentifier isEqualToString:@"MileageAmountCell"])
    {
        UITextField* mileageAmountField = (UITextField*)[cell viewWithTag:1];
        
        VPNMileageList* mileageList = (VPNMileageList*)self.donationList;
        mileageAmountField.text = [mileageList.mileage stringValue];
    }
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

-(IBAction) itemSourceDonePushed:(id)sender
{
    [self hideItemSourcePicker];
}

-(IBAction) displayDatePicker
{
    if(organizationPickerDisplayed)
        [self hideOrganizationPicker];
    
    if(itemSourcePickerDisplayed)
        [self hideItemSourcePicker];
    
    //Show filter picker view
    if(!datePickerDisplayed)
    {
        datePickerDisplayed = YES;
        [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect frame = self.datePickerView.frame;
            frame.origin.y -= frame.size.height;
            
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
            frame.origin.y += frame.size.height;
            
            self.datePickerView.frame = frame;
        }
                         completion:nil];
    }
}


-(IBAction) displayOrganizationPicker
{
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
            frame.origin.y -= frame.size.height;
            
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
            frame.origin.y += frame.size.height;
            
            self.organizationPickerView.frame = frame;
        }
                         completion:nil];
    }
}

-(IBAction) displayItemSourcePicker
{
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
            frame.origin.y -= frame.size.height;
            
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
            frame.origin.y += frame.size.height;
            
            self.itemSourcePickerView.frame = frame;
        }
                         completion:nil];
    }
}


- (void)viewDidUnload {
    [self setListTypeSelector:nil];
    [super viewDidUnload];
}
@end
