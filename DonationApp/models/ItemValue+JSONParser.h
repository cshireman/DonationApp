//
//  ItemValue+JSONParser.h
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "ItemValue.h"

@interface ItemValue (JSONParser)

+(ItemValue*) itemValueWithDictionary:(NSDictionary*) info;

@end
