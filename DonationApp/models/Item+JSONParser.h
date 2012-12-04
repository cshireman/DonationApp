//
//  Item+JSONParser.h
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "Item.h"

@interface Item (JSONParser)

+(Item*) getByItemID:(int)itemID;
-(void) populateWithDictionary:(NSDictionary*)info;

@end
