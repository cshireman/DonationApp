//
//  VPNMainTabGroupViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/17/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNMainTabGroupViewController.h"

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


@end
