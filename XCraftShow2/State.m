//
//  State.m
//  XCraftShow2
//
//  Created by Alex Vye on 2012-09-22.
//
//

#import "State.h"

@implementation State

@synthesize selectedProduct;

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
        self.selectedProduct = nil;
	}
    
	return self;
}

-(void)clear {
    self.selectedProduct = nil;
}

@end
