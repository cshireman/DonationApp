//
//  VPNTabBarHighlighter.m
//  DonationApp
//
//  Created by Chris Shireman on 1/10/13.
//  Copyright (c) 2013 Chris Shireman. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VPNTabBarHighlighter.h"
#import "UIColor+ColorFromHex.h"


@implementation VPNTabBarHighlighter
@synthesize highlightView;
@synthesize highlightIndex;
@synthesize myTabBar;


- (CGRect)frameForTabInTabBar:(UITabBar*)tabBar withIndex:(NSUInteger)index
{
    NSUInteger currentTabIndex = 0;
    
    for (UIView* subView in tabBar.subviews)
    {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            if (currentTabIndex == index)
                return subView.frame;
            else
                currentTabIndex++;
        }
    }
    
    NSAssert(NO, @"Index is out of bounds");
    return CGRectMake(0, 0, 0, 0);
}

- (UIView*)highlightViewInTabBar:(UITabBar*)tabBar
{
    for (UIView* subView in tabBar.subviews)
    {
        if (subView.tag == 99)
        {
            return subView;
        }
    }

    return nil;
}

-(void) highlightTabInTabBar:(UITabBar*)tabBar withIndex:(NSUInteger)index
{
    CGRect tabFrame = [self frameForTabInTabBar:tabBar withIndex:index];
    
    self.highlightView = [self highlightViewInTabBar:tabBar];
    
    if(self.highlightView == nil)
    {
        self.highlightView = [[UIView alloc] initWithFrame:tabFrame];
        self.highlightView.tag = 99;
    }
    else
    {
        self.highlightView.frame = tabFrame;
        return;
    }
    
    self.highlightView.alpha = 0.5;
    self.highlightView.layer.cornerRadius = 10;
    self.highlightView.backgroundColor = [UIColor colorWithHexString:@"#1FEF06"];
    
    [tabBar addSubview:self.highlightView];
}

-(void) startHighlightingTabBar:(UITabBar*)tabBar
{
    self.myTabBar = tabBar;

    self.highlightIndex = 1;
    
    [self highlightTabInTabBar:tabBar withIndex:highlightIndex];
    
    tabTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(moveToNextTab)
                                   userInfo:nil
                                    repeats:YES];
    UIAlertView* welcomeAlert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"Use buttons below.  Start with Organizaitons, then Donations.\nLast email Reports." delegate:self cancelButtonTitle:@"Don't Show Again" otherButtonTitles:@"OK", nil];
    
    [welcomeAlert show];
}

-(void) stopHighlighting
{
    [tabTimer invalidate];
    
    UIView* theHighlight = [self highlightViewInTabBar:self.myTabBar];
    if(theHighlight != nil)
        [theHighlight removeFromSuperview];
}

-(void) moveToNextTab
{
    self.highlightIndex += 1;
    if(self.highlightIndex > 3)
        self.highlightIndex = 1;
    
    NSLog(@"Next Tab:%d",self.highlightIndex);
    [self highlightTabInTabBar:self.myTabBar withIndex:self.highlightIndex];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"welcome_shown"];
        [defaults synchronize];
    }
    
    [self stopHighlighting];
    
}

@end
