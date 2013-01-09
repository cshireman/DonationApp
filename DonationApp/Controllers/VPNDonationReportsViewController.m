//
//  VPNDonationReportsViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VPNDonationReportsViewController.h"
#import "VPNUser.h"
#import "VPNItemList.h"
#import "UIColor+ColorFromHex.h"

@interface VPNDonationReportsViewController ()

@end

@implementation VPNDonationReportsViewController
@synthesize selectedDonationLists;
@synthesize donationLists;
@synthesize delegate;
@synthesize doneButton;
@synthesize gradientView;

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

    VPNUser* user = [VPNUser currentUser];
    donationLists = [NSMutableArray arrayWithArray:[VPNItemList loadItemListsFromDisc:user.selected_tax_year]];
    
    selectedDonationLists = [NSMutableArray array];
    
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
    return [donationLists count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectAllCell";
    if(indexPath.row > 0)
        CellIdentifier = @"DonationListCell";
    else
        CellIdentifier = @"SelectAllCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIImageView* checkboxImage = (UIImageView*)[cell viewWithTag:1];
    
    if(indexPath.row == 0)
    {
        UILabel* listTitle = (UILabel*)[cell viewWithTag:2];
        UILabel* listSubitle = (UILabel*)[cell viewWithTag:3];
        
        listTitle.text = @"Select All";
        listSubitle.text = @"";
        
        if([selectedDonationLists count] == [donationLists count])
            checkboxImage.image = [UIImage imageNamed:@"checkbox_checked"];
        else
            checkboxImage.image = [UIImage imageNamed:@"checkbox_unchecked"];
    }
    else
    {
        int index = indexPath.row - 1;
        VPNItemList* itemList = [donationLists objectAtIndex:index];
        
        if([selectedDonationLists containsObject:itemList])
            checkboxImage.image = [UIImage imageNamed:@"checkbox_checked"];
        else
            checkboxImage.image = [UIImage imageNamed:@"checkbox_unchecked"];
        
        UILabel* listTitle = (UILabel*)[cell viewWithTag:2];
        UILabel* listSubitle = (UILabel*)[cell viewWithTag:3];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        
        listTitle.text = itemList.name;
        NSString* donationDate = [formatter stringFromDate:itemList.donationDate];
        
        listSubitle.text = [NSString stringWithFormat:@"%@ (%@)",donationDate,itemList.howAquired];
        
    }
    
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
    if(indexPath.row == 0)
    {
        if([selectedDonationLists count] != [donationLists count])
        {
            [selectedDonationLists removeAllObjects];
            [selectedDonationLists addObjectsFromArray:donationLists];
        }
        else
        {
            [selectedDonationLists removeAllObjects];
        }
    }
    else
    {
        int index = indexPath.row - 1;
        VPNItemList* itemList = [donationLists objectAtIndex:index];
        
        if([selectedDonationLists containsObject:itemList])
        {
            [selectedDonationLists removeObject:itemList];
        }
        else
        {
            [selectedDonationLists addObject:itemList];
        }
    }
    
    if([selectedDonationLists count] > 0)
        doneButton.tintColor = [UIColor blueColor];
    else
        doneButton.tintColor = nil;
    
    [tableView reloadData];
}

- (void)viewDidUnload {
    [self setDoneButton:nil];
    [super viewDidUnload];
}

- (IBAction)donePushed:(id)sender {
    [delegate donationReportsControllerSelectedDonationLists:selectedDonationLists];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
