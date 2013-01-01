//
//  VPNViewPhotoViewController.h
//  DonationApp
//
//  Created by Chris Shireman on 12/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNViewPhotoDelegate.h"
#import "GradientButton.h"

@interface VPNViewPhotoViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) id<VPNViewPhotoDelegate> delegate;

@property (strong, nonatomic) UIImage* image;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet GradientButton *deleteButton;
@property (strong, nonatomic) IBOutlet GradientButton *changeButton;

- (IBAction)changePushed:(id)sender;
- (IBAction)deletePushed:(id)sender;
@end
