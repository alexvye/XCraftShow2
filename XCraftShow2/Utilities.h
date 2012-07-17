//
//  Utilities.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(NSString*) formatAsCurrency:(NSNumber*)amount;
+(NSString*) formatAsDecimal:(NSNumber*)amount;

@end
