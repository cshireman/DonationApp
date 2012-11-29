//
//  VPNOverlayViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 11/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNOverlayViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface VPNOverlayViewController ()

@end

@implementation VPNOverlayViewController

@synthesize loadingView;
@synthesize progressBar;
@synthesize loadingLabel;
@synthesize descriptionLabel;

-(id) init
{
    self = [super initWithNibName:@"VPNOverlayViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
    
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
	// Do any additional setup after loading the view.
    
    CGRect frame = loadingView.frame;
    frame.origin.x = 30;
    frame.origin.y = 100;
    loadingView.frame = frame;

    loadingView.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLoadingLabel:nil];
    [self setDescriptionLabel:nil];
    [self setProgressBar:nil];
    [self setLoadingView:nil];
    [super viewDidUnload];
}

-(void) show
{
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow insertSubview:loadingView aboveSubview:mainWindow];
}

-(void) hide
{
    //TODO: Add fade-out animation
    [loadingView removeFromSuperview];
}

-(void) setLoadingText:(NSString*)text
{
    loadingLabel.text = text;
}

-(void) setDescriptionText:(NSString*)text
{
    descriptionLabel.text = text;
}

-(void) setProgressPercent:(double)percent
{
    [progressBar setProgress:(percent/100.0) animated:YES];
}

-(void) showProgressBar:(BOOL)show
{
    [progressBar setHidden:!show];
}

-(void) showDescriptionLabel:(BOOL)show
{
    [descriptionLabel setHidden:!show];
}

+(VPNOverlayViewController*) displayOverlay
{
    return [VPNOverlayViewController displayOverlayWithLoadingText:nil descriptionText:nil];
}

+(VPNOverlayViewController*) displayOverlayWithLoadingText:(NSString*)loading
{
    return [VPNOverlayViewController displayOverlayWithLoadingText:loading descriptionText:nil];
}

+(VPNOverlayViewController*) displayOverlayWithLoadingText:(NSString*)loading descriptionText:(NSString*)description
{
    return nil;
}

@end
