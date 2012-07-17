//
//  Product.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sale;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSNumber * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * productDescription;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * unitCost;
@property (nonatomic, retain) NSNumber * defaultCost;
@property (nonatomic, retain) NSSet *saleRel;
@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addSaleRelObject:(Sale *)value;
- (void)removeSaleRelObject:(Sale *)value;
- (void)addSaleRel:(NSSet *)values;
- (void)removeSaleRel:(NSSet *)values;
@end
