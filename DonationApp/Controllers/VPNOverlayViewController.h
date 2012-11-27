//
//  VPNOverlayViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 11/22/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPNOverlayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UILabel *loadingLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

-(void) show;
-(void) hide;

-(void) setLoadingText:(NSString*)text;
-(void) setDescriptionText:(NSString*)text;
-(void) setProgressPercent:(double)percent;

-(void) showProgressBar:(BOOL)show;
-(void) showDescriptionLabel:(BOOL)show;

+(VPNOverlayViewController*) displayOverlay;
+(VPNOverlayViewController*) displayOverlayWithLoadingText:(NSString*)loading;
+(VPNOverlayViewController*) displayOverlayWithLoadingText:(NSString*)loading descriptionText:(NSString*)description;

@end
