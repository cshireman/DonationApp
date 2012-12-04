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
    [VPNNotifier postNotification:notification withUserInfo:nil];
}

+(void) postNotification:(NSString *)notification withUserInfo:(NSDictionary*)userInfo
{
    NSNotification* note = [NSNotification notificationWithName:notification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

@end
