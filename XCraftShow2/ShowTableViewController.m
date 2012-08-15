//
//  ShowTableViewController.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define SECONDS_IN_WEEK 3600*24*7.0

#import "ShowTableViewController.h"
#import "SalesTableViewController.h"
#import "CustomShowCell.h"
#import "Show.h"
#import "Sale.h"
#import "Product.h"
#import "SellViewController_ipod.h"
#import "Utilities.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>

static NSString *CellIdentifier = @"Normal Cell";

@implementation ShowTableViewController

@synthesize eventsList, eventStore, defaultCalendar, detailViewController;

float rowHeight;
NSPredicate* predicate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showModal:)
                                                     name:@"show modal"
                                                   object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // Load events
    //
    predicate = [self.eventStore predicateForEventsWithStartDate:[NSDate date] endDate:[[NSDate date ] dateByAddingTimeInterval:SECONDS_IN_WEEK] calendars:nil];
    
    //
    // Set constants for different devices
    //
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        rowHeight = 44.0;
    } else {
        rowHeight = 99.0; 
    }
    self.tableView.rowHeight = rowHeight;
    
    //
	// Edit button for reordering of array
	//
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(turnOnEditing)];
    
    //
    // Button for adding Shows
    //
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addShow:)];
	self.navigationItem.leftBarButtonItem = plusButton;
}

- (void)turnOnEditing {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(turnOffEditing)];
    [self.tableView setEditing:YES animated:YES];
}

- (void)turnOffEditing {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(turnOnEditing)];
    [self.tableView setEditing:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self turnOffEditing];
    if(self.tableView != nil) {
        [self.tableView reloadData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([[self eventStore] eventsMatchingPredicate:predicate].count < 8) {
        return 8;
    } else {
        return [[self eventStore] eventsMatchingPredicate:predicate].count;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    // Data section
    //
    UITableViewCell* cell;
    
    if(indexPath.row+1>[[self eventStore] eventsMatchingPredicate:predicate].count) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] 
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    } else {
    
        cell =  [self.tableView dequeueReusableCellWithIdentifier:CustomShowCellIdentifier];
        if (cell == nil) {
            cell = [[CustomShowCell alloc] initWithFrame:CGRectZero reuseIdentifier:CustomShowCellIdentifier];
        }
    
    //
    // Configure the cell...
    //
        [self configureCell:(CustomShowCell*)cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row +1 > [[self eventStore] eventsMatchingPredicate:predicate].count) {
        return false;
    } else {
        return true;
    } 
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //
        // delete the event
        //
        EKEvent* event = [ [[self eventStore] eventsMatchingPredicate:predicate] objectAtIndex:indexPath.row];
        NSError *error = nil;
        [self.eventStore removeEvent:event span:EKSpanThisEvent commit:true error:&error];

        //
        [self.tableView endUpdates];

    } 
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row+1>[[self eventStore] eventsMatchingPredicate:predicate].count) {
        
        //
        // no-op
        //
        
    } else {
        //
        // push the view controller
        //
        EKEventEditViewController* controller = [[EKEventEditViewController alloc] init];
        controller.eventStore = self.eventStore;
        controller.editViewDelegate = self;
        controller.event = [[[self eventStore] eventsMatchingPredicate:predicate] objectAtIndex:indexPath.row];
        [self presentModalViewController:controller animated:YES];
    }
}

-(IBAction) addShow: (UIButton*) aButton {
	//
	// push the view controller
	//
    EKEventEditViewController* controller = [[EKEventEditViewController alloc] init];
    controller.eventStore = self.eventStore;
    controller.editViewDelegate = self;
    [self presentModalViewController:controller animated:YES];
}

- (void)configureCell:(CustomShowCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    EKEvent* event = [[[self eventStore] eventsMatchingPredicate:predicate] objectAtIndex:indexPath.row];
    
    cell.showNameLabel.text = event.title;
    NSString *dateString = [DATE_FORMATTER stringFromDate:event.startDate];
    cell.showDateLabel.text = dateString;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

- (NSNumber*)calulateProfit:(Show*)show 
{    
    double sum = 0.0 - show.fee.doubleValue;
    
    Product*product;
    for(Sale* sale in show.saleRel) {
        sum += sale.amount.doubleValue;
        product = sale.productRel;
        sum -= product.unitCost.doubleValue * sale.quantity.intValue;
    }
    
    return [NSNumber numberWithDouble:sum];
}

#pragma mark -
#pragma mark Add a new event

// If event is nil, a new event is created and added to the specified event store. New events are
// added to the default calendar. An exception is raised if set to an event that is not in the
// specified event store.
- (void)addEvent:(id)sender {
    // When add button is pushed, create an EKEventEditViewController to display the event.
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    
    // set the addController's event store to the current event store.
    addController.eventStore = self.eventStore;
    
    // present EventsAddViewController as a modal view controller
    [self presentModalViewController:addController animated:YES];
    
    addController.editViewDelegate = self;
}


#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action {
    
    NSError *error = nil;
    EKEvent *thisEvent = controller.event;
    
    switch (action) {
        case EKEventEditViewActionCanceled:
            // Edit action canceled, do nothing.
            break;
            
        case EKEventEditViewActionSaved:
        {
            // When user hit "Done" button, save the newly created event to the event store,
            // and reload table view.
            // If the new event is being added to the default calendar, then update its
            // eventsList.
            
            if (self.defaultCalendar ==  thisEvent.calendar) {
                [self.eventsList addObject:thisEvent];
            }
            //
            // Save event in event store
            //
            
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent commit:true error:&error];
            
            //
            // Save new show
            //
            [self saveShow:thisEvent];
            
        }
            break;
            
        case EKEventEditViewActionDeleted:
            // When deleting an event, remove the event from the event store,
            // and reload table view.
            // If deleting an event from the currenly default calendar, then update its
            // eventsList.
            if (self.defaultCalendar ==  thisEvent.calendar) {
                [self.eventsList removeObject:thisEvent];
            }
            [controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
            break;
            
        default:
            break;
    }
    // Dismiss the modal view controller
    [controller dismissModalViewControllerAnimated:YES];
    
}

// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
    EKCalendar *calendarForEdit = self.defaultCalendar;
    return calendarForEdit;
}

- (void)saveShow:(EKEvent*)event {
    
}


- (void) showModal:(NSNotification *) notification
{
    SalesTableViewController* salesView = [[SalesTableViewController alloc]
                                            initWithNibName:@"SalesTableViewController" bundle:nil];
	//
	// Pass the selected object to the new view controller.
	//
    salesView.title = @"Sales";
     [self.navigationController pushViewController:salesView animated:true];
}

@end