//
//  VPNSelectTaxYearViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 11/15/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSelectTaxYearViewController.h"
#import "VPNUser.h"
#import "VPNAppDelegate.h"

@interface VPNSelectTaxYearViewController ()
{
    VPNUser* currentUser;
    VPNCDManager* manager;
}

@end

@implementation VPNSelectTaxYearViewController

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
    
    currentUser = [VPNUser currentUser];
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if(currentUser.tax_years != nil)
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
        cell.imageView.image = [UIImage imageNamed:@"checked"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"unchecked"];
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

    [manager getItemListsForTaxYear:currentUser.selected_tax_year forceDownload:YES];
}

#pragma mark -
#pragma mark Manager Delegate methods

//GetItemLists
-(void) didGetItemLists:(NSArray*)itemLists
{
    [manager getCashListsForTaxYear:currentUser.selected_tax_year forceDownload:YES];
}

-(void) getItemListsFailedWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"There was a problem downloading your item lists, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

//GetCashLists
-(void) didGetCashLists:(NSArray*)cashLists
{
    [manager getMileageListsForTaxYear:currentUser.selected_tax_year forceDownload:YES];
}

-(void) getCashListsFailedWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"There was a problem downloading your cash lists, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];    
}

//GetMileageLists
-(void) didGetMileageLists:(NSArray*)mileageLists
{
    [manager getCategoryListForTaxYear:currentUser.selected_tax_year forceDownload:YES];
}

-(void) getMileageListsFailedWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"There was a problem downloading your mileage lists, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

//GetCategoryList
-(void) didGetCategoryList:(NSDictionary*)categoryList
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) getCategoryListFailedWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"There was a problem our database, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}


@end
