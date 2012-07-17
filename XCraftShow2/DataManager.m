//
//  DataManager.m
//  XFloss
//
//  Created by Alex Vye on 10-08-05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

NSMutableArray *shows;
NSMutableArray *products;
NSMutableArray *inventory;

@implementation DataManager


////////////////////////////////
// end of save and load routines
////////////////////////////////

+(void) startup {
    //
    // some dummy data to get us started
    //
    shows = [[NSMutableArray alloc] initWithObjects:@"s1", @"s2",@"s3",nil];
    products = [[NSMutableArray alloc] initWithObjects:@"p1", @"p2",@"p3",nil];
    inventory = [[NSMutableArray alloc] initWithObjects:@"i1", @"i2",@"i3",nil];    
}


//
// clean up memory
//
- (void)dealloc {
}
			  
@end
