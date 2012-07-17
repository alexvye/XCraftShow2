//
//  Show.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-05-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Sale;

@interface Show : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * fee;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * rules;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Contact *contactRel;
@property (nonatomic, retain) NSSet *saleRel;
@end

@interface Show (CoreDataGeneratedAccessors)

- (void)addSaleRelObject:(Sale *)value;
- (void)removeSaleRelObject:(Sale *)value;
- (void)addSaleRel:(NSSet *)values;
- (void)removeSaleRel:(NSSet *)values;
@end
