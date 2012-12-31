//
//  VPNPurchaseTaxYearViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/30/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNPurchaseTaxYearViewController.h"
#import "VPNUser.h"
#import "VPNCDManager.h"

#import "DejalActivityView.h"

@interface VPNPurchaseTaxYearViewController ()
{
    NSMutableArray* purchaseOptions;
    NSMutableArray* selectedOptions;
    VPNUser* user;
    VPNCDManager* manager;
    
    BOOL usePromoPrice;
}
@end

@implementation VPNPurchaseTaxYearViewController

@synthesize promoCodeField;
@synthesize tableView;
@synthesize buyNowButton;
@synthesize applyPromoCodeButton;

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
    usePromoPrice = NO;
    user = [VPNUser currentUser];
    purchaseOptions = user.available_tax_years;
    selectedOptions = [NSMutableArray array];
	// Do any additional setup after loading the view.
    
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    //Automatically select tax year for trial user
    if(user.is_trial)
    {
        for(NSNumber* year in purchaseOptions)
        {
            if([year isEqualToNumber:[NSNumber numberWithInt:user.selected_tax_year]])
            {
                [selectedOptions addObject:year];
                break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPromoCodeField:nil];
    [self setTableView:nil];
    [self setBuyNowButton:nil];
    [self setApplyPromoCodeButton:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

-(UITableViewCell*) tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"TaxYearCell";
    
    UITableViewCell* cell = [localTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSNumber* year = [purchaseOptions objectAtIndex:indexPath.row];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([selectedOptions count] >= 2)
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - ($%.02f)",year,user.discount_rate];
    else
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - ($%.02f)",year,user.single_rate];
    
    if([selectedOptions containsObject:year])
        cell.imageView.image = [UIImage imageNamed:@"checkbox_checked"];
    else
        cell.imageView.image = [UIImage imageNamed:@"checkbox_unchecked"];
    
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)localTableView numberOfRowsInSection:(NSInteger)section
{
    return [purchaseOptions count];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber* year = [purchaseOptions objectAtIndex:indexPath.row];
    if([selectedOptions containsObject:year])
        [selectedOptions removeObject:year];
    else
        [selectedOptions addObject:year];
    
    if([selectedOptions count] >= 2)
        usePromoPrice = YES;
    else
        usePromoPrice = NO;
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        //Show email dialog
    }
}

#pragma mark -
#pragma mark VPNCDManagerDelegate Methods

//GetYears
-(void) didGetTaxYears:(NSArray*)taxYears
{
    [DejalBezelActivityView currentActivityView].activityLabel.text = @"Updating Purchase Options";
    [manager getPurchaseOptions];
}

-(void) getTaxYearsFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Update Error" message:@"Unable to update tax years at this time.  Please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alert show];
}

//GetPurchaseOptions
-(void) didGetPurchaseOptions:(NSDictionary*)info
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) getPurchaseOptionsFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Update Error" message:@"Unable to update tax years at this time.  Please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alert show];    
}

//ValidatePromoCode
-(void) didValidatePromoCode:(NSDictionary*)info
{
    [DejalBezelActivityView removeViewAnimated:YES];
    usePromoPrice = YES;
    [self.tableView reloadData];
}

-(void) validatePromoCodeFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"Unable to validate promo code at this time.  Please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alert show];
    
}

//AddPurchasedYear
-(void) didAddPurchasedYear:(NSDictionary*)info
{
    [selectedOptions removeObjectAtIndex:0];
    if([selectedOptions count] > 0)
    {
        [self processNextPurchase];
    }
    else
    {
        [DejalBezelActivityView currentActivityView].activityLabel.text = @"Loading Tax Years";
        [manager getTaxYears:YES];
    }
}

-(void) addPurchasedYearFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Purchase Error" message:@"Unable to register your purchase at this time.  Please contact technical support" delegate:self cancelButtonTitle:@"Close" otherButtonTitles: @"Contact",nil];
    
    [alert show];
    
}


#pragma mark -
#pragma mark Custom Methods

- (IBAction)applyPromoCodePushed:(id)sender
{
    if([promoCodeField.text length] > 0)
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Validating Code" width:155];
        [manager validatePromoCode:promoCodeField.text];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Promo Code" message:@"Please enter a promo code before proceeding." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        
        [alert show];
    }
}

- (IBAction)buyNowPushed:(id)sender
{
//TO-DO:  Add code for in-app purchase
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Purchasing Tax Years" width:155];
    
}

-(void) processNextPurchase
{
    if([selectedOptions count] > 0)
    {
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithCapacity:3];
        [info setObject:promoCodeField.text forKey:@"promoCode"];
        
        if(usePromoPrice)
            [info setObject:[NSNumber numberWithDouble:user.discount_rate] forKey:@"purchasePrice"];
        else
            [info setObject:[NSNumber numberWithDouble:user.single_rate] forKey:@"purchasePrice"];
        
        [info setObject:[selectedOptions objectAtIndex:0] forKey:@"year"];
        
        [manager addPurchasedYearWithInfo:info];
    }
}
@end
