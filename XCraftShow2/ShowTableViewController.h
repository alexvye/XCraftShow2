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
#import "UICustomSwitch.h"

@interface ShowTableViewController : UITableViewController<EKEventEditViewDelegate> {
    EKEventViewController *detailViewController;
    EKEventStore *eventStore;
    EKCalendar *defaultCalendar;
    NSMutableArray *eventsList;
}

@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) EKEventViewController *detailViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) UICustomSwitch *editSwitch;

- (void)configureCell:(CustomShowCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSNumber*)calulateProfit:(Show*)show;
- (IBAction)edit:(id)sender;

@end
