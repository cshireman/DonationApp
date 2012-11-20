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
	// Do any additional setup after loading the view.
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

-(void) loginControllerFinished
{
    [self dismissModalViewControllerAnimated:YES];
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
}


@end
