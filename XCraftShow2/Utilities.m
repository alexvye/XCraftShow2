//
//  Utilities.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

NSNumberFormatter* CURRENCY_FORMATTER;
NSNumberFormatter* NUMBER_FORMATTER;
NSDateFormatter* DATE_FORMATTER;

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
    NSNumberFormatter *aCurrency = [[NSNumberFormatter alloc] init];
    [aCurrency setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [aCurrency setNumberStyle:NSNumberFormatterDecimalStyle];   
    [aCurrency setMinimumFractionDigits:0];
    [aCurrency setMaximumFractionDigits:0];
    [aString appendString:[aCurrency stringFromNumber:amount]];
    
    return aString;
}

+(NSString*) truncateString:(NSString*)input:(int)length {
    //
    // first reduct string to length or smaller
    //
    NSString* result = ([input length]>length ? [input substringToIndex:length] : input);
    
    //
    // then pad out to length
    //
    if(result.length < length) {
        int blanks = length - result.length;
        NSString* padString = @"";
        for(int i=0;i<blanks;i++) {
            padString = [padString stringByAppendingString:@" "];
        }
        result = [result stringByAppendingString:padString];
    }
    
    //
    // the return it
    //
    return result;
}

@end
