//
//  State.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-09-22.
//
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface State : NSObject {
    
}

@property (nonatomic, retain) Product *selectedProduct;

+(State*)instance;
-(void)clear;
@end