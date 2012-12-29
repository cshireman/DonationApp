//
//  VPNViewPhotoViewController.m
//  DonationApp
//
//  Created by Chris Shireman on 12/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNViewPhotoViewController.h"

@interface VPNViewPhotoViewController ()

@end

@implementation VPNViewPhotoViewController

@synthesize delegate;
@synthesize image;
@synthesize imageView;
@synthesize deleteButton;
@synthesize changeButton;

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

-(void) viewWillAppear:(BOOL)animated
{
    imageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImage:nil];
    [self setDeleteButton:nil];
    [self setChangeButton:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if(buttonIndex == 1)
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIImagePickerController* imageController = [[UIImagePickerController alloc] init];
    imageController.sourceType = sourceType;
    imageController.delegate = self;
    imageController.allowsEditing = YES;
    
    [self presentViewController:imageController animated:YES completion:^{}];    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    image = imageView.image;
    
    if(imageView.image == nil)
    {
        imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = imageView.image;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];    
    [self.delegate viewPhotoViewControllerUpdatedPhoto:imageView.image];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];    
}

#pragma mark -
#pragma mark Custom Methods

- (IBAction)changePushed:(id)sender {
    UIActionSheet* imageSourceSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    
    [imageSourceSheet showInView:self.view];    
}

- (IBAction)deletePushed:(id)sender {
    [delegate viewPhotoViewControllerDeletedPhoto];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
