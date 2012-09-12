//
//  ShowTableViewController.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"

@interface ShowTableViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (assign, nonatomic) BOOL editingShow;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSNumber*)calulateProfit:(Show*)show;

@end
