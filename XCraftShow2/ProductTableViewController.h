//
//  ProductTableViewController.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProductCell.h"

@interface ProductTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(CustomProductCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)insertNewObject;

@end
