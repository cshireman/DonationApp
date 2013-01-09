//
//  UIColor+ColorFromHex.h
//  BehrCSC
//
//  Created by Chris Shireman on 8/28/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorFromHex)
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
@end
