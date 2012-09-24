//
//  State.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-09-22.
//
//

/*
#define kSHOW_FEE         @"ShowFee"
#define kUNIT_COST        @"UnitCost"
#define kDEFAULT_PRICE    @"DefaultPrice"
#define kSALE_PRICE       @"SalePrice"
#define kSELECTED_PRODUCT @"SelectedProduct"
#define kSHOW_NAME        @"ShowName"
#define kSHOW_DATE        @"ShowDate"
*/

#import <Foundation/Foundation.h>

static NSString* SHOW_FEE = @"ShowFee";
static NSString* UNIT_COST = @"UnitCost";
static NSString* DEFAULT_PRICE = @"DefaultPrice";
static NSString* SALE_PRICE = @"SalePrice";
static NSString* SELECTED_PRODUCT = @"SelectedProduct";
static NSString* SHOW_NAME = @"ShowName";
static NSString* SHOW_DATE = @"ShowDate";

@interface State : NSObject {
    
}

@property (nonatomic, retain) NSMutableDictionary *mem;

+(State*)instance;
-(void)clear;
@end