//
//  ShowTableViewController.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomShowCell.h"
#import "Show.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface ShowTableViewController : UITableViewController<NSFetchedResultsControllerDelegate,EKEventEditViewDelegate> {
    EKEventViewController *detailViewController;
    EKEventStore *eventStore;
    EKCalendar *defaultCalendar;
    NSMutableArray *eventsList;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) EKEventViewController *detailViewController;

- (void)configureCell:(CustomShowCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)insertNewObject;
- (void)generateRecurringShows;
- (void)saveShow:(EKEvent*)event;

- (NSNumber*)calulateProfit:(Show*)show;

@end
