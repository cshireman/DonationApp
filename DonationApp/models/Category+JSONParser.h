//
//  Category+JSONParser.h
//  DonationApp
//
//  Created by Chris Shireman on 12/3/12.
//  Copyright (c) 2012 Chris Shireman. All rights reserved.
//

#import "Category.h"

@interface Category (JSONParser)

+(Category*) getByCategoryID:(int)categoryID;
+(NSArray*) getByTaxYear:(int)taxYear;

-(void) populateWithDictionary:(NSDictionary*)info;

@end
