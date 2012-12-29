//
//  VPNViewPhotoDelegate.h
//  DonationApp
//
//  Created by Chris Shireman on 12/29/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VPNViewPhotoViewController;

@protocol VPNViewPhotoDelegate <NSObject>

-(void) viewPhotoViewControllerDeletedPhoto;
-(void) viewPhotoViewControllerUpdatedPhoto:(UIImage*)updatedImage;

@end
