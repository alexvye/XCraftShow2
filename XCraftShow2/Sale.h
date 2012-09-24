//
//  Sale.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-09-24.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product, Show;

@interface Sale : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) Product *productRel;
@property (nonatomic, retain) Show *showRel;

@end
