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
    NSMutableArray* completedTransactions;
    VPNUser* user;
    VPNCDManager* manager;
    
    UIAlertView* noTaxYearsAlert;
    UIAlertView* paymentProcessingAlert;
    UIAlertView* paymentSuccessAlert;
    UIAlertView* addPurchasedYearAlert;
    
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
    
    [applyPromoCodeButton useBlackActionSheetStyle];
    [buyNowButton useGreenConfirmStyle];
    
    usePromoPrice = NO;
    user = [VPNUser currentUser];
    purchaseOptions = user.available_tax_years;
    
    
    
    selectedOptions = [NSMutableArray array];
    completedTransactions = [NSMutableArray array];
	// Do any additional setup after loading the view.
    
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //Automatically select tax year for trial user
    if(user.is_trial)
    {
        BOOL currentYearFound = NO;
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
        
        NSInteger currentYear = [components year];
        if(user.selected_tax_year != 0)
            currentYear = user.selected_tax_year;
        
        for(NSNumber* year in purchaseOptions)
        {
            if([year isEqualToNumber:[NSNumber numberWithInt:currentYear]])
            {
                currentYearFound = YES;
            }
        }
        
        //Add the current tax year if it isn't already there
        if(!currentYearFound)
        {
            [purchaseOptions addObject:@(currentYear)];
            [purchaseOptions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2];
            }];
        }
        
        
        for(NSNumber* year in purchaseOptions)
        {
            if([year isEqualToNumber:[NSNumber numberWithInt:currentYear]])
            {
                [selectedOptions addObject:year];
                break;
            }
        }
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    if([purchaseOptions count] == 0)
    {
        noTaxYearsAlert = [[UIAlertView alloc] initWithTitle:@"No Available Tax Years" message:@"You currently have access to all available tax years" delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
        
        [noTaxYearsAlert show];
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
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        
    if([selectedOptions count] >= 2)
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - ($%.02f)",year,user.discount_rate+.04];
    else
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - ($%.02f)",year,user.single_rate+.04];
    
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
    if(alertView == noTaxYearsAlert)
        [self.navigationController popViewControllerAnimated:YES];
    else if(alertView == paymentProcessingAlert)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
            [mailController setToRecipients:@[@"support@charitydeductions.com"]];
            [mailController setSubject:@"App Store purchase problem"];
            
            mailController.mailComposeDelegate = self;
            
            [self presentViewController:mailController animated:YES completion:^{}];
        }
    }
    else if(alertView == addPurchasedYearAlert)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
            [mailController setToRecipients:@[@"support@charitydeductions.com"]];
            [mailController setSubject:@"App Store problem adding paid tax year."];
            
            mailController.mailComposeDelegate = self;
            
            [self presentViewController:mailController animated:YES completion:^{}];
        }
    }
    else if(alertView == paymentSuccessAlert)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            NSURL* url = [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=492358634"];
            [[UIApplication sharedApplication] openURL:url];
        }
        
        [VPNNotifier postNotification:@"RemoveAds"];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark -
#pragma mark MFMailComposeViewController Delegate methods

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
    
    paymentSuccessAlert = [[UIAlertView alloc] initWithTitle:@"Tax Year Added" message:@"Thank you for your purchase. We hope you save on your taxes this year and become a yearly customer. You can also access your account at www.charitydeductions.com. Could you please rate our app in the Apple Store?" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Rate Us", nil];
    
    [paymentSuccessAlert show];
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
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Valid Promo Code" message:@"Your promo code has been accepted, please proceed with your purchase." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) validatePromoCodeFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Promo Code" message:@"Your promo code has been rejected, please double check that you entered the correct code and try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
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
    addPurchasedYearAlert = [[UIAlertView alloc] initWithTitle:@"Payment Processing Error" message:@"There was a problem adding your purchased tax year. Please contact us." delegate:self cancelButtonTitle:@"Close" otherButtonTitles: @"Contact Us",nil];
    
    [addPurchasedYearAlert show];
    
}

#pragma mark -
#pragma mark SKProductRequestDelegate Methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray* products = response.products;
    
    if([products count] > 0)
    {
        for(SKProduct* product in products)
        {
            SKPayment *payment = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }
    else
    {
        [DejalBezelActivityView removeViewAnimated:YES];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Communication Error" message:@"Unable to connect to Apple's payment system. Check your network connection or try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver Methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark Custom Methods

-(void) completeTransaction:(SKPaymentTransaction*)transaction
{
    [completedTransactions addObject:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if([completedTransactions count] == [selectedOptions count])
    {
        [self processNextPurchase];
    }
}

-(void) failedTransaction:(SKPaymentTransaction*)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        paymentProcessingAlert = [[UIAlertView alloc] initWithTitle:@"Payment Processing Error" message:@"We were unable to complete your purchase request. Please try again or contact us." delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
        
        [paymentProcessingAlert show];
    }
    
    NSRange lastFourCharacters = NSMakeRange([transaction.payment.productIdentifier length]-5, 4);
    NSString* productYearString = [transaction.payment.productIdentifier substringWithRange:lastFourCharacters];
    NSNumber* productYear = [NSNumber numberWithInt:[productYearString intValue]];
    
    NSNumber* optionToRemove = nil;
    for(NSNumber* selectedYear in selectedOptions)
    {
        if([selectedYear isEqualToNumber:productYear])
        {
            optionToRemove = selectedYear;
            break;
        }
    }
    
    if(optionToRemove != nil)
        [selectedOptions removeObject:optionToRemove];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if([completedTransactions count] == [selectedOptions count])
    {
        [self processNextPurchase];
    }
}

-(void) restoreTransaction:(SKPaymentTransaction*)transaction
{
    [self completeTransaction:transaction];
}

- (IBAction)applyPromoCodePushed:(id)sender
{
    if([promoCodeField.text length] > 0)
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Validating Code" width:155];
        [manager validatePromoCode:promoCodeField.text];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Promo Code Required" message:@"Please enter a valid promo code and try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        
        [alert show];
    }
}

- (IBAction)buyNowPushed:(id)sender
{
    if([selectedOptions count] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a year." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    [completedTransactions removeAllObjects];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Purchasing Tax Years" width:155];
    NSString* productPrefix = @"SingleRate";
    if([selectedOptions count] >= 2 || usePromoPrice)
    {
        productPrefix = @"DiscountRate";
    }
    
    NSMutableSet* productIDs = [[NSMutableSet alloc] initWithCapacity:[selectedOptions count]];
    
    for(NSNumber* yearToPurchase in selectedOptions)
    {
        NSString* productID =[NSString stringWithFormat:@"%@TaxYear%@",productPrefix,yearToPurchase];
        NSLog(@"ProductID: %@",productID);
        [productIDs addObject:productID];
    }
    
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: productIDs];
    request.delegate = self;
    [request start];
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
