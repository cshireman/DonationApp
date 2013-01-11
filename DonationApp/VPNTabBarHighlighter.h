//
//  VPNTabBarHighlighter.h
//  DonationApp
//
//  Created by Chris Shireman on 1/10/13.
//  Copyright (c) 2013 Chris Shireman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPNTabBarHighlighter : NSObject <UIAlertViewDelegate>
{
    NSTimer* tabTimer;
}
@property (strong, nonatomic) UIView* highlightView;
@property (strong, nonatomic) UITabBar* myTabBar;
@property (assign) int highlightIndex;

- (CGRect)frameForTabInTabBar:(UITabBar*)tabBar withIndex:(NSUInteger)index;
-(void) highlightTabInTabBar:(UITabBar*)tabBar withIndex:(NSUInteger)index;

-(void) startHighlightingTabBar:(UITabBar*)tabBar;
-(void) stopHighlighting;
-(void) moveToNextTab;


@end
