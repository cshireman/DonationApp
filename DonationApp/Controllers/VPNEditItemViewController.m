//
//  VPNEditItemViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/28/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNEditItemViewController.h"
static CGFloat keyboardHeight = 216;
static CGFloat toolbarHeight = 44;
static CGFloat tabBarHeight = 49;

@interface VPNEditItemViewController ()
{
    VPNCDManager* manager;
}


@end

@implementation VPNEditItemViewController

@synthesize itemCellNib;
@synthesize doneToolbarNib;

@synthesize group;
@synthesize doneButton;
@synthesize doneToolbar;

-(UINib*) customItemCellNib
{
    if(itemCellNib == nil)
    {
        self.itemCellNib = [VPNItemConditionCell nib];
    }
    
    return itemCellNib;
}

-(UINib*) doneToolbarNib
{
    if(doneToolbarNib == nil)
    {
        self.doneToolbarNib = [VPNDoneToolbar nib];
    }
    
    return doneToolbarNib;
}

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

    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
    
    doneToolbar = [VPNDoneToolbar doneToolbarFromFromNib:[VPNDoneToolbar nib]];
    doneToolbar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    }
    else if([CellIdentifier isEqualToString:@"VPNItemNameCell"])
    {
        VPNItemNameCell *itemNameCell = [VPNItemNameCell cellForTableView:localTableView fromNib:self.itemNameCellNib];
        
        itemNameCell.delegate = self;
        
        itemNameCell.indexPath = indexPath;
        [itemNameCell setText:group.itemName];
        
        return itemNameCell;
        
    }
    else if([CellIdentifier isEqualToString:@"VPNItemConditionCell"])
    {
        VPNItemConditionCell *conditionCell = [VPNItemConditionCell cellForTableView:tableView fromNib:self.itemCellNib];
        
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
