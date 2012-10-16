//
//  VPNSplashViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 10/15/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "VPNSplashViewController.h"

@interface VPNSplashViewController ()

@end

@implementation VPNSplashViewController

@synthesize firstImage;
@synthesize secondImage;

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
    [self startAnimation];
}

-(void)viewDidUnload
{
    self.firstImage = nil;
    self.secondImage = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Start the splash screen animation.  This animation waits for 2 seconds, then fades the first image away.
 * Once the first image fades away, the second image is displayed for 1 second.  Following that, the main 
 * app segue is triggered.
 */
-(void) startAnimation
{
    [UIView animateWithDuration:0.2f delay:3.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                        self.firstImage.layer.opacity = 0.0;
                     }
                     completion:^(BOOL finished){
                         if(finished)
                         {
                             [self performSelector:@selector(gotoMainApp) withObject:nil afterDelay:2.0];
                         }
                     }
     ];
    
}

/**
 * Go to the main app using the IntroSegue;
 */
-(void) gotoMainApp
{
    [self performSegueWithIdentifier:@"IntroSegue" sender:self];
}

@end
