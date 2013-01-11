//
//  VPNSelectTaxYearViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 11/15/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import "VPNSelectTaxYearViewController.h"
#import "VPNUser.h"
#import "VPNAppDelegate.h"
#import "Category.h"
#import "Category+JSONParser.h"

#import "DejalActivityView.h"

@interface VPNSelectTaxYearViewController ()
{
    VPNUser* currentUser;
    VPNCDManager* manager;
}

@end

@implementation VPNSelectTaxYearViewController

@synthesize showPurchaseButton;
@synthesize purchaseView;
@synthesize buyNowButton;
@synthesize loadingView;

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
    
    [buyNowButton useGreenConfirmStyle];
    
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setInstallLabel:) name:@"InstallingCategories" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInstallLabel:) name:@"CategoryInstallProgress" object:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    currentUser = [VPNUser currentUser];
    
    [self.navigationController setNavigationBarHidden:NO];
    if(showPurchaseButton)
    {
        [purchaseView setHidden:NO];
    }
    else
        [purchaseView setHidden:YES];
    
    [self.tableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(currentUser.tax_years == nil)
        return 0;
    
    return [currentUser.tax_years count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaxYearCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSNumber* taxYear = [currentUser.tax_years objectAtIndex:indexPath.row];
    
    if(currentUser.selected_tax_year != 0 && [taxYear intValue] == currentUser.selected_tax_year)
    {
        cell.imageView.image = [UIImage imageNamed:@"checkbox_checked"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"checkbox_unchecked"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d",[taxYear intValue]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    NSNumber* selectedYear = [currentUser.tax_years objectAtIndex:indexPath.row];
    currentUser.selected_tax_year = [selectedYear intValue];
    
    [currentUser saveAsDefaultUser];
    [self.tableView reloadData];

    self.loadingView = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading Item Lists" width:155];
    [manager getItemListsForTaxYear:currentUser.selected_tax_year forceDownload:YES];
}


#pragma mark -
#pragma mark Manager Delegate methods

//GetItemLists
-(void) didGetItemLists:(NSArray*)itemLists
{
    loadingView.activityLabel.text = @"Loading Cash Lists";
    
    [manager getCashListsForTaxYear:currentUser.selected_tax_year forceDownload:YES];
}

-(void) getItemListsFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"There was a problem downloading your item lists, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

//GetCashLists
-(void) didGetCashLists:(NSArray*)cashLists
{
    loadingView.activityLabel.text = @"Loading Mileage Lists";
    
    [manager getMileageListsForTaxYear:currentUser.selected_tax_year forceDownload:YES];
}

-(void) getCashListsFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES]; 
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"There was a problem downloading your cash lists, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];    
}

//GetMileageLists
-(void) didGetMileageLists:(NSArray*)mileageLists
{
    [DejalBezelActivityView removeViewAnimated:NO];
    loadingView = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading Database\nThis will take several minutes.\nDo not close the app." width:230];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [manager getCategoryListForTaxYear:currentUser.selected_tax_year forceDownload:NO];
}

-(void) getMileageListsFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"There was a problem downloading your mileage lists, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

//GetCategoryList
-(void) didGetCategoryList:(NSArray*)categoryList
{
    //Test if we need to install the database or just dismiss the overlay
    if([categoryList count] > 0 && [[categoryList objectAtIndex:0] isKindOfClass:[NSDictionary class]])
    {
        [DejalBezelActivityView removeViewAnimated:NO];
        loadingView = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Installing: 0.0%%" width:230];
        
        VPNAppDelegate* appDelegate = (VPNAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = [appDelegate managedObjectContext];
        
        NSNumber* taxYear = [NSNumber numberWithInt:currentUser.selected_tax_year];
        NSError* error = nil;
        
        double i = 0.00;
        for(id categoryInfo in categoryList)
        {
            NSMutableDictionary* mutableCatInfo = [NSMutableDictionary dictionaryWithDictionary:categoryInfo];
            [mutableCatInfo setValue:taxYear forKey:@"TaxYear"];
            
            NSNumber* catID = [mutableCatInfo objectForKey:@"ID"];
            Category* category  = [Category newCategoryForCategoryID:[catID intValue]];
            [category populateWithDictionary:mutableCatInfo];
            
            [context save:&error];
            
            i += 1.0;
            double progress = (i / [categoryList count])*100.0;
            
            [DejalActivityView currentActivityView].activityLabel.text = [NSString stringWithFormat: @"Installing: %.02f%%",progress];
        }
    }

    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [VPNTaxSavings updateTaxSavings];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    [VPNNotifier postNotification:@"ShowWelcome"];
}

-(void) getCategoryListFailedWithError:(NSError*)error
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"There was a problem with our database, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}


#pragma mark -
#pragma mark Custom Methods

-(void) setCanPurchase:(NSNumber*)canPurchase
{
    showPurchaseButton = [canPurchase boolValue];
}

-(IBAction) buyNowPushed:(UIButton*)sender
{
    
    if([SKPaymentQueue canMakePayments])
    {
        [self performSegueWithIdentifier:@"BuyNowSegue" sender:self];
    }
    else
    {        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"InApp Purchase Unavailable" message:@"InApp purchases are currently unavailable.  Please check your settings and try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    }
}


-(void) setInstallLabel:(NSNotification*)notification
{
    
}

-(void) updateInstallLabel:(NSNotification*)notification
{
    
}


- (void)viewDidUnload {
    [self setBuyNowButton:nil];
    [super viewDidUnload];
}
@end
