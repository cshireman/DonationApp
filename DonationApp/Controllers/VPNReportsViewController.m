//
//  VPNReportsViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIColor+ColorFromHex.h"
#import "VPNReportsViewController.h"
#import "VPNUser.h"

#import "DejalActivityView.h"

@interface VPNReportsViewController ()
{
    VPNCDManager* manager;
}

@end

@implementation VPNReportsViewController

@synthesize sendItemizedReport;
@synthesize sendTaxSummaryReport;
@synthesize donationLists;

@synthesize taxYearLabel;
@synthesize emailReportsButton;
@synthesize tableView;

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
    [emailReportsButton useGreenConfirmStyle];
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    sendItemizedReport = NO;
    sendTaxSummaryReport = NO;
    
    if(donationLists == nil)
        donationLists = [[NSMutableArray alloc] init];
    
    [donationLists removeAllObjects];
}

-(void) viewWillAppear:(BOOL)animated
{
    UIView* gradientView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,44)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"#d4d4d4"] CGColor], (id)[[UIColor colorWithHexString:@"#999999"] CGColor], (id)[[UIColor colorWithHexString:@"#b4b4b4"] CGColor], nil];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    
    [self.tableHeader addSubview:gradientView];
    [self.tableHeader sendSubviewToBack:gradientView];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    VPNUser* user = [VPNUser currentUser];
    NSString* taxYearText = [NSString stringWithFormat:@"Tax Year %d",user.selected_tax_year];
    taxYearLabel.text = taxYearText;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTaxYearLabel:nil];
    [self setEmailReportsButton:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

-(UITableViewCell*) tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"ReportCell";
    
    UITableViewCell* cell = [localTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    UILabel* reportTitle = (UILabel*)[cell viewWithTag:2];
    UILabel* reportSubtitle = (UILabel*)[cell viewWithTag:3];
    
    if(indexPath.row == 0)
    {
        if(sendItemizedReport)
            imageView.image = [UIImage imageNamed:@"checkbox_checked"];
        else
            imageView.image = [UIImage imageNamed:@"checkbox_unchecked"];
        
        reportTitle.text = @"Itemized Detail";
        reportSubtitle.text = @"- Save for your records";
    }
    else if(indexPath.row == 1)
    {
        if(sendTaxSummaryReport)
            imageView.image = [UIImage imageNamed:@"checkbox_checked"];
        else
            imageView.image = [UIImage imageNamed:@"checkbox_unchecked"];
        
        reportTitle.text = @"Tax Summary";
        reportSubtitle.text = @"- Give to your CPA";
    }
    else if(indexPath.row == 2)
    {
        if([donationLists count] > 0)
            imageView.image = [UIImage imageNamed:@"checkbox_checked"];
        else
            imageView.image = [UIImage imageNamed:@"checkbox_unchecked"];
        
        reportTitle.text = @"Donation Reports";
        reportSubtitle.text = @"- Use when you donate";
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
-(void) tableView:(UITableView *)localTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        sendItemizedReport = !sendItemizedReport;
    }
    else if(indexPath.row == 1)
    {
        sendTaxSummaryReport = !sendTaxSummaryReport;
    }
    else if(indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"ItemizedSegue" sender:self];
    }
    
    [localTableView deselectRowAtIndexPath:indexPath animated:YES];
    [localTableView reloadData];
}

-(void) tableView:(UITableView *)localTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"ItemizedSegue" sender:self];
    }
    
    [localTableView deselectRowAtIndexPath:indexPath animated:YES];
    [localTableView reloadData];
}

#pragma mark -
#pragma mark Segue Methods

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destination = segue.destinationViewController;
    
    if([destination respondsToSelector:@selector(setDelegate:)])
    {
        [destination setValue:self forKey:@"delegate"];
    }
    
    if([destination respondsToSelector:@selector(setCanPurchase:)])
    {
        [destination performSelector:@selector(setCanPurchase:) withObject:[NSNumber numberWithBool:NO]];
    }
}

#pragma mark -
#pragma mark VPNCDManagerDelegate Methods

-(void) didSendItemizedSummaryReport
{
    [self processNextReport];
}

-(void) didSendTaxPrepSummaryReport
{
    [self processNextReport];
}

-(void) didSendDonationListReportWithValues
{
    if([donationLists count] > 0)
    {
        [donationLists removeObjectAtIndex:0];
    }
        
    [self processNextReport];
}

-(void) handleReportError
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error Sending Reports" message:@"Reports could not be sent at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alert show];
}

-(void) sendDonationListReportWithValuesFailedWithError:(NSError *)error
{
    [self handleReportError];
}

-(void) sendItemizedSummaryReportFailedWithError:(NSError *)error
{
    [self handleReportError];
}

-(void) sendTaxPrepSummaryReportFailedWithError:(NSError *)error
{
    [self handleReportError];
}

#pragma mark -
#pragma mark VPNDonationReportsDelegate Methods

-(void) donationReportsControllerSelectedDonationLists:(NSArray*)selectedDonationLists
{
    donationLists = [NSMutableArray arrayWithArray:selectedDonationLists];
}


#pragma mark -
#pragma mark Custom Methods

-(void) processNextReport
{
    VPNUser* user = [VPNUser currentUser];
    
    if(sendItemizedReport)
    {
        sendItemizedReport = NO;
        [manager sendItemizedSummaryReport:user.selected_tax_year];
    }
    else if(sendTaxSummaryReport)
    {
        sendTaxSummaryReport = NO;
        [manager sendTaxPrepSummaryReport:user.selected_tax_year];
    }
    else if([donationLists count] > 0)
    {
        [manager sendDonationListReportWithValues:[donationLists objectAtIndex:0]];
    }
    else
    {
        [DejalBezelActivityView removeViewAnimated:YES];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Reports Sent" message:@"All selected reports have been sent." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        
        [alert show];
    }
}

- (IBAction)taxYearButtonPushed:(id)sender {
    [self performSegueWithIdentifier:@"SelectTaxYearSegue" sender:self];
}

- (IBAction)emailReportsPushed:(id)sender {
    if(!sendItemizedReport && !SendTaxPrepSummaryReport && [donationLists count] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Report Selected" message:@"Please choose at least one report" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        
        [alert show];
    }
    else
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Sending Reports" width:155];
        [self processNextReport];
    }
}
@end
