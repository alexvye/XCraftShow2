//
//  ProductTableViewController.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRoduct.h"

@interface ProductTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign, getter=isSelecting) BOOL selecting;
@property (strong, nonatomic) Product* selProduct;

- (void)insertNewObject;

@end
