//
//  Utilities.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(NSString*) formatAsCurrency:(NSNumber*)amount {
    
    if(amount == nil) {
        amount = [NSNumber numberWithInt:0];
    }
    NSMutableString *aString = [NSMutableString stringWithCapacity:30];
    NSNumberFormatter *aCurrency = [[NSNumberFormatter alloc]init];
    [aCurrency setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [aCurrency setNumberStyle:NSNumberFormatterCurrencyStyle];   
    [aCurrency setMinimumFractionDigits:2];
    [aCurrency setMaximumFractionDigits:2];
    [aString appendString:[aCurrency stringFromNumber:amount]];
    
    return aString;
}

+(NSString*) formatAsDecimal:(NSNumber*)amount {
    
    if(amount == nil) {
        amount = [NSNumber numberWithInt:0];
    }
    NSMutableString *aString = [NSMutableString stringWithCapacity:30];
    NSNumberFormatter *aCurrency = [[NSNumberFormatter alloc]init];
    [aCurrency setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [aCurrency setNumberStyle:NSNumberFormatterDecimalStyle];   
    [aCurrency setMinimumFractionDigits:0];
    [aCurrency setMaximumFractionDigits:0];
    [aString appendString:[aCurrency stringFromNumber:amount]];
    
    return aString;
}

@end
