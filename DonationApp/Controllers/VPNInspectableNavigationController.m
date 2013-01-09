//
//  VPNInspectableNavigationController.m
//  DonationApp
//
//  Created by Chris Shireman on 1/9/13.
//  Copyright (c) 2013 Chris Shireman. All rights reserved.
//

#import "VPNInspectableNavigationController.h"

@interface VPNInspectableNavigationController ()

@end

@implementation VPNInspectableNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated
{
    [super beginAppearanceTransition:isAppearing animated:animated];
    NSLog(@"Inspectable: beingAppearanceTransition:%d animated:%d",isAppearing,animated);
}

-(void) endAppearanceTransition
{
    [super endAppearanceTransition];
    NSLog(@"Inspectable: endAppearanceTransition");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Inspectable: viewDidLoad");
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"Inspectable: viewWillAppear");
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"Inspectable: viewDidAppear");
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"Inspectable: viewDidLayoutSubviews");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
