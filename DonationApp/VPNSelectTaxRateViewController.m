//
//  VPNSelectTaxRateViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSelectTaxRateViewController.h"

@interface VPNSelectTaxRateViewController ()

@end

@implementation VPNSelectTaxRateViewController
@synthesize delegate;
@synthesize taxRates;
@synthesize selectedTaxRate;
@synthesize taxRateTable;

-(id) init
{
    self = [super init];
    if(self)
    {
        [self config];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self config];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self config];
	// Do any additional setup after loading the view.
    [self.taxRateTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) config
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    self.selectedTaxRate = [userDefaults objectForKey:kSelectedTaxRateKey];
    if(self.selectedTaxRate == nil)
        self.selectedTaxRate = @"25%";
    
    self.taxRates = [[NSMutableArray alloc] initWithObjects:@"10%",@"15%",@"25%",@"28%",@"33%",@"35%", nil];    
}

#pragma mark -
#pragma mark UITableViewDataSourceMethods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = nil;
    
    if(tableView != nil)
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.taxRates objectAtIndex:indexPath.row];
    if([cell.textLabel.text isEqualToString:self.selectedTaxRate])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.taxRates count];
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTaxRate = [self.taxRates objectAtIndex:indexPath.row];
    if(tableView != nil)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView reloadData];
    }
}

#pragma mark -
#pragma mark - Custom methods

-(IBAction)savePushed:(id)sender
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.selectedTaxRate forKey:kSelectedTaxRateKey];
    [userDefaults synchronize];
    
    [VPNTaxSavings updateTaxSavings];
    
    if(self.delegate != nil)
    {
        [self.delegate selectTaxRateSaved];
    }
}

-(IBAction)cancelPushed:(id)sender
{
    if(self.delegate != nil)
    {
        [self.delegate selectTaxRateCanceled];
    }
    
}


@end
