//
//  VPNSelectTaxRateViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNSelectTaxRateViewController.h"

@interface VPNSelectTaxRateViewController ()

@end

@implementation VPNSelectTaxRateViewController
@synthesize delegate;

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
#pragma mark - Custom methods

-(IBAction)savePushed:(id)sender
{
    if(self.delegate != nil)
    {
        [self.delegate selectTaxRateSaved];
    }
}

-(IBAction)cancelPushed:(id)sender
{
    if(self.delegate != nil)
    {
        [self.delegate selectTaxRateCanceled];
    }
    
}


@end
