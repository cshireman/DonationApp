//
//  VPNEditCustomItemViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/19/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNEditCustomItemViewController.h"
#import "VPNModalPickerView.h"
#import "Category.h"

@interface VPNEditCustomItemViewController ()
{
    VPNModalPickerView* modalPicker;
    NSArray* categories;
    
    UITextField* currentTextField;
}
@end

@implementation VPNEditCustomItemViewController

@synthesize customItemCellNib;
@synthesize doneToolbarNib;

@synthesize group;
@synthesize itemNameField;
@synthesize tableView;
@synthesize doneButton;
@synthesize doneToolbar;

-(UINib*) customItemCellNib
{
    if(customItemCellNib == nil)
    {
        self.customItemCellNib = [VPNCustomItemConditionCell nib];
    }
    
    return customItemCellNib;
}

-(UINib*) doneToolbarNib
{
    if(doneToolbarNib == nil)
    {
        self.doneToolbarNib = [VPNDoneToolbar nib];
    }
    
    return doneToolbarNib;
}


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
    
    itemNameField = [[UITextField alloc] init];
    itemNameField.text = group.itemName;
    itemNameField.placeholder = @"Enter Item Name";
    
    modalPicker = [[VPNModalPickerView alloc] initWithNibName:[VPNModalPickerView nibName]];
    categories = [Category loadCategoriesForCategoryID:0];
    
    modalPicker.options = categories;
    modalPicker.delegate = self;
    
    doneToolbar = [VPNDoneToolbar doneToolbarFromFromNib:[VPNDoneToolbar nib]];
    doneToolbar.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [modalPicker addToView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

-(void) replaceTextField:(UITextField*)textField inCell:(UITableViewCell*)cell forTag:(int)tag
{
    UITextField* cellField = (UITextField*)[cell viewWithTag:tag];
    textField.frame = cellField.frame;
    
    [cellField removeFromSuperview];
    [cell.contentView addSubview:textField];
}

-(UITableViewCell*) tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"VPNCustomItemConditionCell";
    UITableViewCell* cell = nil;
    
    if(indexPath.section == 0 && indexPath.row == 0)
        CellIdentifier = @"CategoryCell";
    else if(indexPath.section == 0 && indexPath.row == 1)
        CellIdentifier = @"ItemCell";
    else if(indexPath.section == 1 && indexPath.row == 0)
        CellIdentifier = @"ColumnHeaderCell";
    else if(indexPath.section == 1 && indexPath.row == 6)
        CellIdentifier = @"PhotoCell";
    
    
    if(![CellIdentifier isEqualToString:@"VPNCustomItemConditionCell"])
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
        else if([CellIdentifier isEqualToString:@"ItemCell"])
        {
            [self replaceTextField:itemNameField inCell:cell forTag:1];
        }
    }
    else
    {
        VPNCustomItemConditionCell *conditionCell = [VPNCustomItemConditionCell cellForTableView:localTableView fromNib:self.customItemCellNib];
        
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

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    else
        return 7;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row != 6)
        return NO;
    
    if(indexPath.section == 0 && indexPath.row == 1)
        return NO;
    
    return YES;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        for(int i = 0; i < [categories count]; i++)
        {
            Category* currentCategory = (Category*)[categories objectAtIndex:i];
            
            if([currentCategory.name isEqualToString:group.categoryName])
            {
                modalPicker.selectedIndex = i;
            }
        }
        
        [modalPicker show];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark VPNCustomItemConditionCellDelegate Methods

-(void) quantityUpdated:(int)quantity atIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"Updating Quantity: %d for row %d",quantity,indexPath.row);
    switch(indexPath.row)
    {
        case 1: [group setQuantity:quantity forCondition:Mint]; break;
        case 2: [group setQuantity:quantity forCondition:Excellent]; break;
        case 3: [group setQuantity:quantity forCondition:VeryGood]; break;
        case 4: [group setQuantity:quantity forCondition:Good]; break;
        case 5: [group setQuantity:quantity forCondition:Fair]; break;
        default: break;
    }
}

-(void) fmvUpdated:(double)fmv atIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"Updating Value: %.02f for row %d",fmv,indexPath.row);
    switch(indexPath.row)
    {
        case 1: [group setValue:fmv forCondition:Mint]; break;
        case 2: [group setValue:fmv forCondition:Excellent]; break;
        case 3: [group setValue:fmv forCondition:VeryGood]; break;
        case 4: [group setValue:fmv forCondition:Good]; break;
        case 5: [group setValue:fmv forCondition:Fair]; break;
        default: break;
    }
}

-(void) quantityField:(UITextField*)quantityField focusedAtIndexPath:(NSIndexPath*)indexPath
{
    quantityField.inputAccessoryView = doneToolbar;
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    currentTextField = quantityField;
}

-(void) fmvField:(UITextField*)fmvField focusedAtIndexPath:(NSIndexPath*)indexPath
{
    fmvField.inputAccessoryView = doneToolbar;
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    currentTextField = fmvField;
}


#pragma mark -
#pragma mark VPNModalPickerViewDelegate

-(void) optionWasSelectedAtIndex:(int)selectedIndex
{
    Category* localCategory = [categories objectAtIndex:selectedIndex];
    group.categoryName = localCategory.name;
    
    NSLog(@"Category Name: %@",group.categoryName);
}

-(void) pickerWasDismissed
{
    NSLog(@"Picker dismissed");
    if(group.categoryName == nil || [group.categoryName isEqualToString:@""])
    {
        Category* localCategory = [categories objectAtIndex:0];
        group.categoryName = localCategory.name;
    }
    
    [self.tableView reloadData];
}

-(void) pickerWasDisplayed
{
    NSLog(@"Picker displayed");
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
}

#pragma mark -
#pragma mark VPNDoneToolbarDelegate Methods

-(void) doneToolbarButtonPushed:(id)sender
{
    if(currentTextField != nil)
    {
        [currentTextField resignFirstResponder];
        currentTextField = nil;
    }
}


@end
