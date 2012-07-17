//
//  ProductSelectorTableViewController.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProductCell.h"
#import "Product.h"

@interface ProductSelectorTableViewController : UITableViewController

@property (strong, nonatomic) Product* selProduct;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSArray*)getProducts;
- (void)configureCell:(CustomProductCell*)cell atIndexPath:(NSIndexPath *)indexPath;

@end
