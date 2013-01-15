//
//  VPNOrganizationDetailViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 11/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNOrganizationDetailViewController.h"
#import "DejalActivityView.h"

@interface VPNOrganizationDetailViewController ()
{
    NSMutableArray* organizations;
    UITextField* currentTextField;
}

@property (strong, nonatomic) VPNCDManager* manager;

@end

@implementation VPNOrganizationDetailViewController
@synthesize nameField;
@synthesize addressField;
@synthesize cityField;
@synthesize stateField;
@synthesize zipField;

@synthesize deleteButton;
@synthesize doneButton;

@synthesize organization;
@synthesize manager;

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
    organizations = [VPNOrganization loadOrganizationsFromDisc];
	// Do any additional setup after loading the view.
    
    [deleteButton useRedDeleteStyle];
    
    if(organization == nil)
    {
        organization = [[VPNOrganization alloc] init];
        [deleteButton setHidden:YES];
    }
    else
    {
        nameField.text = organization.name;
        addressField.text = organization.address;
        cityField.text = organization.city;
        stateField.text = organization.state;
        zipField.text = organization.zip_code;
        
        [deleteButton setHidden:NO];
    }
    
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameField:nil];
    [self setAddressField:nil];
    [self setCityField:nil];
    [self setStateField:nil];
    [self setZipField:nil];
    
    [self setDeleteButton:nil];
    [self setOrganization:nil];
    
    [super viewDidUnload];
}


- (IBAction)deletePushed:(id)sender {
    UIActionSheet* deleteConfirm = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this Organization?  It cannot be undone." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
    
    [deleteConfirm showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.destructiveButtonIndex)
    {
        //Call delete organization API call
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Deleting Organization" width:155];
        [manager deleteOrganization:organization];
    }
    
    [actionSheet resignFirstResponder];
}

- (IBAction)donePushed:(id)sender {
    if(currentTextField != nil)
        [currentTextField resignFirstResponder];
    
    //IF name field is blank
    if([nameField.text isEqualToString:@""])
    {
        //Show error and exit
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Organization" message:@"Organization Name required" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        
        return;
    }//END IF
    
    //populate organization object
    organization.name = nameField.text;
    organization.address = addressField.text;
    organization.city = cityField.text;
    organization.state = stateField.text;
    organization.zip_code = zipField.text;
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Saving Organization" width:155];
    //IF organization ID is set
    if(organization.ID != 0)
    {
        //Call update organization API call
        [manager updateOrganization:organization];
    }
    else //ELSE no organization ID set
    {
        //Call create organization API call
        [manager addOrganization:organization];
    }
    //ENDIF
}

#pragma mark -
#pragma mark VPNCDManagerDelegate methods

//AddOrganization
-(void) didAddOrganization:(VPNOrganization*)addedOrganization
{
    [DejalBezelActivityView removeViewAnimated:YES];
    //Add organization to list
    [organizations addObject:addedOrganization];
    //Save list
    [VPNOrganization saveOrganizationsToDisc:organizations];
    //Pop view controller
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) addOrganizationFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"Unable to save organization at this time, please try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

//UpdateOrganization
-(void) didUpdateOrganization:(VPNOrganization*)updatedOrganization
{
    [DejalBezelActivityView removeViewAnimated:YES];
    //Find organization in list
    VPNOrganization* foundOrg = nil;
    for(VPNOrganization* currentOrg in organizations)
    {
        if(currentOrg.ID == updatedOrganization.ID)
       {
           foundOrg = currentOrg;
       }
    }

    //Replace organization in list
    if(foundOrg != nil)
    {
        NSUInteger orgIndex = [organizations indexOfObject:foundOrg];
        [organizations replaceObjectAtIndex:orgIndex withObject:updatedOrganization];
    }
    
    //Save list
    [VPNOrganization saveOrganizationsToDisc:organizations];
    //Pop view controller
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) updateOrganizationFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"Unable to save organization at this time, please try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

//DeleteOrganization
-(void) didDeleteOrganization
{
    [DejalBezelActivityView removeViewAnimated:YES];
    //Find organization in list
    VPNOrganization* foundOrg = nil;
    for(VPNOrganization* currentOrg in organizations)
    {
        if(currentOrg.ID == organization.ID)
        {
            foundOrg = currentOrg;
        }
    }
    
    //Replace organization in list
    if(foundOrg != nil)
    {
        [organizations removeObject:foundOrg];
    }
    
    //Save list
    [VPNOrganization saveOrganizationsToDisc:organizations];
    //Pop view controller
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) deleteOrganizationFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Delete Error" message:@"Unable to delete organization at this time, please try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    doneButton.tintColor = [UIColor blueColor];
    
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
}

@end
