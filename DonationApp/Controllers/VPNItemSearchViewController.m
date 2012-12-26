//
//  VPNItemSearchViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/26/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNItemSearchViewController.h"
#import "Category.h"
#import "Item.h"
#import "VPNItemGroup.h"

@interface VPNItemSearchViewController ()
{
    Category* currentCategory;
    NSArray* categories;
    NSArray* items;
    
    VPNItemGroup* group;
    
    UIBarButtonItem* backButton;
}
@end

@implementation VPNItemSearchViewController

@synthesize results;
@synthesize donationList;
@synthesize itemSearchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) keywordSearch:(NSString*)keyword
{
    categories = [Category keywordSearch:keyword];
    items = [Item keywordSearch:keyword];
    
    results = [NSMutableArray arrayWithArray:categories];
    [results addObjectsFromArray:items];    
}

-(void) loadCurrentCategory
{
    categories = [Category loadCategoriesForCategoryID:[currentCategory.categoryID intValue]];
    items = [Item loadItemsForCategoryID:[currentCategory.categoryID intValue]];
    
    results = [NSMutableArray arrayWithArray:categories];
    [results addObjectsFromArray:items];
}

-(void) backButtonPushed
{
    if([currentCategory.categoryID intValue] != 0)
    {
        currentCategory.categoryID = currentCategory.parentCategoryID;
        [self loadCurrentCategory];
        
        NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    //Remove back button if at the root level
    if([currentCategory.categoryID intValue] == 0)
    {
        self.navigationItem.leftBarButtonItem = nil;
        [itemSearchBar setHidden:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPushed)];
    
    currentCategory = [[Category alloc] init];
    [currentCategory setCategoryID:[NSNumber numberWithInt:0]];
    [self loadCurrentCategory];

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
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    id resultObject = [results objectAtIndex:indexPath.row];
    
    if([resultObject isKindOfClass:[Category class]])
    {
        Category* category = (Category*)resultObject;
        cell.textLabel.text = category.name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        Item* item = (Item*)resultObject;
        cell.textLabel.text = item.name;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id resultObject = [results objectAtIndex:indexPath.row];
    
    if([resultObject isKindOfClass:[Category class]])
    {
        self.navigationItem.leftBarButtonItem = backButton;
        [itemSearchBar setHidden:YES];
        
        currentCategory = (Category*)resultObject;
        [self loadCurrentCategory];
        
        NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
    }
    else
    {
        Item* item = (Item*)resultObject;
        group = [[VPNItemGroup alloc] init];
        
        group.itemID = [item.itemID intValue];
        group.itemName = item.name;
        
        group.categoryID = [currentCategory.categoryID intValue];
        group.categoryName = currentCategory.name;
        
        group.donationList = donationList;
        
        [self performSegueWithIdentifier:@"AddItemSegue" sender:self];
    }
    
}

#pragma mark -
#pragma mark Segue Methods

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destination = segue.destinationViewController;
    
    if([destination respondsToSelector:@selector(setGroup:)])
    {
        [destination setValue:group forKey:@"group"];
    }
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
    [self loadCurrentCategory];
    [self.tableView reloadData];
}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:YES animated:YES];
    [results removeAllObjects];
    [self.tableView reloadData];
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self keywordSearch:searchBar.text];
    
    [self.tableView reloadData];
}

@end
