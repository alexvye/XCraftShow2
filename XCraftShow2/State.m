//
//  State.m
//  XCraftShow2
//
//  Created by Alex Vye on 2012-09-22.
//
//

#import "State.h"

@implementation State

@synthesize mem;

static State* _instance = nil;

+(State*)instance

{
    @synchronized (_instance)
    {
        if ( !_instance || _instance == NULL )
        {
            // allocate the shared instance, because it hasn't been done yet
            _instance = [[State alloc] init];
        }
        
        return _instance;
    }
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
        NSNumber* nilPrice = [NSNumber numberWithInt:0];

        self.mem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
               nilPrice, SHOW_FEE,
               nilPrice, UNIT_COST,
               nilPrice, DEFAULT_PRICE,
               nilPrice, SALE_PRICE,
               [NSNull null],SHOW_NAME,
               [NSNull null],SHOW_DATE,
               [NSNull null], SELECTED_PRODUCT, nil];
	}
    
	return self;
}

-(void)clear {
    NSNumber* nilPrice = [NSNumber numberWithDouble:0.00];
    [self.mem setValue:nilPrice forKey:SHOW_FEE];
    [self.mem setValue:nilPrice forKey:UNIT_COST];
    [self.mem setValue:nilPrice forKey:DEFAULT_PRICE];
    [self.mem setValue:nilPrice forKey:SALE_PRICE];
    [self.mem setValue:[NSNull null] forKey:SHOW_NAME];
    [self.mem setValue:[NSNull null] forKey:SHOW_DATE];
    [self.mem setValue:[NSNull null] forKey:SELECTED_PRODUCT];
}

@end
