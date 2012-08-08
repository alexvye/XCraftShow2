//
//  ShowTableViewController.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define SECONDS_IN_WEEK 604800

#import "ShowTableViewController.h"
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

@synthesize managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize eventsList, eventStore, defaultCalendar, detailViewController;

float rowHeight;

int numberObjects;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    // Set constants for different devices
    //
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        rowHeight = 44.0;
    } else {
        rowHeight = 99.0; 
    }
    self.tableView.rowHeight = rowHeight;
    
    //
    //
    
    numberObjects = 0;
    
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
    
    //
    // generate any recurring events
    //
    [self generateRecurringShows];
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
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    numberObjects = [sectionInfo numberOfObjects];
    if([sectionInfo numberOfObjects] < 8) {
        return 8;
    } else {
        return [sectionInfo numberOfObjects];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    // Data section
    //
    UITableViewCell* cell;
    
    if(indexPath.row+1>numberObjects) {
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
    if(indexPath.row +1 > numberObjects) {
        return false;
    } else {
        return true;
    } 
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        Show* show = (Show*) [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSString* eventId = show.eventId;
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        //
        // delete the event
        //
        EKEvent* event = [self.eventStore eventWithIdentifier:eventId];
        [self.eventStore removeEvent:event span:EKSpanThisEvent commit:true error:&error];
        
        //
        [self.tableView endUpdates];

    } 
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row+1>numberObjects) {
        
    } else {
        SellViewController_ipod* detailView;
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            detailView = [[SellViewController_ipod alloc]
                                              initWithNibName:@"SellViewController_ipod" bundle:nil];
        } else {
            detailView = [[SellViewController_ipod alloc]
                                              initWithNibName:@"SellViewController" bundle:nil];
        }
        
        detailView.managedObjectContext = self.managedObjectContext;
        detailView.title = @"Sales";
        detailView.show = (Show*)[self.fetchedResultsController objectAtIndexPath:indexPath];
	//
	// push the view controller
	//
        [self.navigationController pushViewController:detailView animated:YES];
    }
}

-(IBAction) addShow: (UIButton*) aButton {

	//
	// push the view controller
	//
    EKEventStore *store = [[EKEventStore alloc] init];
    EKEventEditViewController* controller = [[EKEventEditViewController alloc] init];
    controller.eventStore = store;
    controller.editViewDelegate = self;
    [self presentModalViewController:controller animated:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Show" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:5]; //default was 20
    
    // Edit the sort key as appropriate.
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
} 

- (void)insertNewObject
{
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:@"Show name" forKey:@"name"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    [self.tableView endUpdates];
}

- (void)configureCell:(CustomShowCell*)cell atIndexPath:(NSIndexPath *)indexPath
{

    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    Show* show = (Show*) managedObject;
    
    cell.showNameLabel.text = show.name;
    NSString *dateString = [DATE_FORMATTER stringFromDate:show.date];
    cell.showDateLabel.text = dateString;
    cell.showProfitLabel.text = [Utilities formatAsCurrency:[self calulateProfit:show]];
    
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

- (void)generateRecurringShows {
    //
    // Recurring shows can go on forever, so this is what we will do:
    // 1. Assume we only care about recurring shows 1 month in advance
    // 2. Get list of events for the next 1 month from current time
    // 3. For each event, check if a show with that event id already exists
    // 4. If not, generate show for event
    //
    
    // list of events for next month
    NSPredicate* predicate = [self.eventStore predicateForEventsWithStartDate:[NSDate date] endDate:[[NSDate date ] dateByAddingTimeInterval:SECONDS_IN_WEEK] calendars:[self.eventStore calendars]];
    NSArray* events = [self.eventStore eventsMatchingPredicate:predicate];
    
    // for each event, check if show exists with that event id
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *showPredicate;
    NSError *error = nil;
    NSArray *results;
    
    for (EKEvent* event in events) {
        showPredicate = [NSPredicate predicateWithFormat:@"eventId == %@", event.eventIdentifier];
        [request setEntity:[NSEntityDescription entityForName:@"Show" inManagedObjectContext:self.managedObjectContext]];
        [request setPredicate:showPredicate];
        results = [self.managedObjectContext executeFetchRequest:request error:&error];
        if([results count] == 0) { // show id does not exist, create new
            [self saveShow:event];
        }
    }
}

- (void)saveShow:(EKEvent*) event {
    Show* show = (Show*) [NSEntityDescription insertNewObjectForEntityForName:@"Show" inManagedObjectContext:self.managedObjectContext];
    show.name = event.title;
    show.fee = [NSNumber numberWithFloat:0.0];
    show.date = event.endDate;
    show.eventId = event.eventIdentifier;
    
    NSLog(@"Event id %@", event.eventIdentifier);
    //
    // Save
    //
    
    NSError *error;
    if(![self.managedObjectContext save:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
    }
}

@end