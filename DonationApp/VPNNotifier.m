//
//  VPNNotifier.m
//  DonationApp
//
//  Created by Chris Shireman on 11/8/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "VPNNotifier.h"

@implementation VPNNotifier

+(void) postNotification:(NSString *)notification
{
    NSNotification* note = [NSNotification notificationWithName:notification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

@end
