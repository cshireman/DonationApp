//
//  VPNMainTabGroupViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/17/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNMainTabGroupViewController.h"
#import "VPNSession.h"
#import "VPNUser.h"

@interface VPNMainTabGroupViewController ()

@end

@implementation VPNMainTabGroupViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    VPNUser* user = [VPNUser loadUserFromDisc];
    if(user == nil)
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];

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

-(void) loginController:(VPNLoginViewController *)login didFinish:(BOOL)status
{
    if(status)
    {
        VPNSession* session = [VPNSession currentSession];
        NSLog(@"Session: %@",session.session);
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Please try again" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        
        [alert show];
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
}


@end
