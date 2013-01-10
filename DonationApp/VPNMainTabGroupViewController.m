//
//  VPNMainTabGroupViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/17/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNMainTabGroupViewController.h"
#import "VPNAppDelegate.h"
#import "VPNSession.h"
#import "VPNUser.h"
#import "Category.h"
#import "Category+JSONParser.h"

#import "DejalActivityView.h"

@interface VPNMainTabGroupViewController ()
{
    VPNCDManager* manager;
    VPNUser* currentUser;
    
    BOOL sessionLoaded;
}

@end

@implementation VPNMainTabGroupViewController

-(id) init
{
    self = [super init];
    if(self)
    {
   //     [self configure];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self configure];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
    
    sessionLoaded = NO;
    
    manager = [[VPNCDManager alloc] init];
    manager.delegate = self;
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void) configure
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayLoginScene) name:@"Logout" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    VPNUser* user = [VPNUser loadUserFromDisc];
    VPNSession* session = [VPNSession currentSession];
    
    if(user == nil)
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    else
    {
        if(!sessionLoaded)
        {
            sessionLoaded = YES;
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Starting Session" width:155];
            if(session.session != nil && [session.session length] > 0)
            {
                [manager idle];
            }
            else
            {
                [manager startSessionForUser:user];
            }
        }
    }

}

#pragma mark -
#pragma mark VPNCDManagerDelegate Methods

-(void) didIdle
{
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading user info";
    [manager getUserInfo:YES];    
}

-(void) idleFailedWithError:(NSError*)error
{
    VPNUser* user = [VPNUser loadUserFromDisc];
    [manager startSessionForUser:user];
}

-(void) startingSessionFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [VPNNotifier postNotification:@"InvalidLoginError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Invalid Username or Password" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) didStartSession
{
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading user info";
    [manager getUserInfo:YES];
}

-(void) getUserInfoFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [VPNNotifier postNotification:@"GetUserInfoError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"We were not able to retrieve your user information at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

-(void) didGetUser:(VPNUser *)theUser
{
    NSParameterAssert(theUser != nil);
    
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading tax years";
    [manager getTaxYears:YES];
}

-(void) getTaxYearsFailedWithError:(NSError *)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [VPNNotifier postNotification:@"GetTaxYearsError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"We were not able to retrieve your tax year information at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
    
}

-(void) didGetTaxYears:(NSArray *)taxYears
{
    NSParameterAssert(taxYears != nil);
    if([taxYears count] == 0)
    {
        [VPNNotifier postNotification:@"GetTaxYearsEmptyError"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"We were not able to retrieve your tax year information at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading Purchase Options";
    [manager getPurchaseOptions];
}

-(void) didGetPurchaseOptions:(NSDictionary *)info
{
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading Organizations";
    [manager getOrganizations:YES];
}

-(void) didGetOrganizations:(NSArray*)organizations
{
    NSParameterAssert(organizations != nil);
    
    currentUser = [VPNUser currentUser];
    if(currentUser.selected_tax_year != 0)
    {
        //Continue with loading sequence
        [DejalBezelActivityView currentActivityView].activityLabel.text = @"Loading Item Lists";
        [manager getItemListsForTaxYear:currentUser.selected_tax_year forceDownload:YES];
    }
    else
    {
        [DejalBezelActivityView removeViewAnimated:YES];
        [self displaySelectTaxYearScene];
    }
}

-(void) getOrganizationsFailedWithError:(NSError*)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    [VPNNotifier postNotification:@"GetOrganizationsError"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"We were not able to retrieve your organization information at this time, please try again later." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
    
}

//GetItemLists
-(void) didGetItemLists:(NSArray*)itemLists
{
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading Cash Lists";
    
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
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading Mileage Lists";
    
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
    [DejalActivityView currentActivityView].activityLabel.text = @"Loading Database";
    
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
        [[DejalActivityView currentActivityView].activityLabel setText:@"Installing"];
        
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
            Category* category  = [Category getByCategoryID:[catID intValue]];
            [category populateWithDictionary:mutableCatInfo];
            
            [context save:&error];
            
            i += 1.0;
            double progress = (i / [categoryList count])*100.0;
            
            [DejalActivityView currentActivityView].activityLabel.text = [NSString stringWithFormat: @"Installing: %.02f%%",progress];
        }
    }
    
    [VPNTaxSavings updateTaxSavings];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    [VPNNotifier postNotification:@"LoginFinished"];
}

-(void) getCategoryListFailedWithError:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"There was a problem with our database, please try again later" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}



#pragma mark -
#pragma mark Custom Methods

-(void) displayLoginScene
{
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

-(void) displaySelectTaxYearScene
{
    [self performSegueWithIdentifier:@"SelectTaxYearSegue" sender:self];
}

#pragma mark -
#pragma mark VPNLoginViewControllerDelegate Methods

-(void) loginControllerFinished
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    [VPNNotifier postNotification:@"LoginFinished"];
    
    VPNUser* user = [VPNUser currentUser];
    if(user.selected_tax_year == 0)
    {
        [self performSegueWithIdentifier:@"SelectTaxYearSegue" sender:self];
    }
}

#pragma mark -
#pragma mark Segue Methods

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destination = segue.destinationViewController;
    
    if([destination respondsToSelector:@selector(viewControllers)])
    {
        NSLog(@"Setting Delegate");
        NSArray* viewControllers = [destination valueForKey:@"viewControllers"];
        if([viewControllers count] > 0)
        {
            if([[viewControllers objectAtIndex:0] respondsToSelector:@selector(setDelegate:)])
               [[viewControllers objectAtIndex:0] setValue:self forKey:@"delegate"];
        }
    }
    
    if([destination respondsToSelector:@selector(setCanPurchase:)])
    {
        [destination performSelector:@selector(setCanPurchase:) withObject:[NSNumber numberWithBool:YES]];
    }
}

#pragma mark -
#pragma mark UINavigationControllerDelegate Methods

-(void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(navigationController == self.navigationController)
    {
        NSLog(@"Will Show %@",viewController);
    }
}



@end
