//
//  State.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-09-22.
//
//

#import <Foundation/Foundation.h>
#import "Product.h"

static NSString* SHOW_FEE = @"ShowFee";
static NSString* UNIT_COST = @"UnitCost";
static NSString* DEFAULT_PRICE = @"DefaultPrice";
static NSString* SALE_PRICE = @"SalePrice";

@interface State : NSObject {
    
}

@property (nonatomic, retain) NSMutableDictionary *mem;
@property (nonatomic, retain) Product *selectedProduct;
@property (nonatomic, retain) NSString *showName;
@property (nonatomic, retain) NSDate *showDate;


+(State*)instance;
-(void)clear;
@end