//
//  ShowTableViewController.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define MIN_SHOW_ROWS 8 // always populate table with 8 rows to avoid the ugly empty table look

static NSString *CellIdentifier = @"Normal Cell";
static NSString *EmptyCellIdentifier = @"Empty Cell";

#define SECONDS_IN_WEEK 3600*24*7.0

#import "ShowTableViewController.h"
#import "SalesTableViewController.h"
#import "Show.h"
#import "Sale.h"
#import "Product.h"
#import "Utilities.h"
#import "ShowViewController_ipod.h"

@implementation ShowTableViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
// put custom init code here
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
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    if([sectionInfo numberOfObjects] < MIN_SHOW_ROWS) {
        return MIN_SHOW_ROWS;
    } else {
        return [sectionInfo numberOfObjects];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    // Data section
    //
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    UITableViewCell* cell;
    
    if(indexPath.row+1>[sectionInfo numberOfObjects])  { // using empty filled rows, basically a no-op
        cell = [tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
        }

    } else {
    
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    
    //
    // Configure the cell...
    //
        [self configureCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    if(indexPath.row +1 > [sectionInfo numberOfObjects]) {
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
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
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
        [self.tableView endUpdates];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    if(indexPath.row+1 > [sectionInfo numberOfObjects]) {
        
        //
        // no-op
        //
        
    } else {
        SalesTableViewController* salesView = [[SalesTableViewController alloc]
                                    initWithNibName:@"SalesTableViewController" bundle:nil];
        //
        // Pass the selected object to the new view controller.
        //
        salesView.title = @"Sales";
        salesView.managedObjectContext = self.managedObjectContext;
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath]; 
        salesView.show = (Show*)managedObject;
        [self.navigationController pushViewController:salesView animated:true];
    }
}

-(IBAction) addShow: (UIButton*) aButton {
    ShowViewController_ipod* showView;
	//
	// push the view controller
	//
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        showView = [[ShowViewController_ipod alloc]
                      initWithNibName:@"ShowViewController_ipod" bundle:nil];
    } else {
        showView = [[ShowViewController_ipod alloc]
                      initWithNibName:@"ShowViewController_ipod" bundle:nil];
    }
    
	//
	// Pass the selected object to the new view controller.
	//
    showView.managedObjectContext = self.managedObjectContext;
    [self presentModalViewController:showView animated:YES];
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    Show* show = (Show*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = show.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, profit = %@",[DATE_FORMATTER stringFromDate:show.date], [CURRENCY_FORMATTER stringFromNumber:[self calulateProfit:show]]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSNumber*)calulateProfit:(Show*)show 
{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    BOOL profit = NO;
    
    if (standardUserDefaults)
        profit = [standardUserDefaults boolForKey:@"profit"];
    
    
    double sum = 0.0 - show.fee.doubleValue;
    
    Product*product;
    for(Sale* sale in show.saleRel) {
        sum += sale.amount.doubleValue;
        product = sale.productRel;
        if(profit) {
            sum -= product.unitCost.doubleValue * sale.quantity.intValue;
        }
    }
    return [NSNumber numberWithDouble:sum];
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
    
    //
    // where clause
    //
    
    /*
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"date == %@", [NSDate date]];
    [fetchRequest setPredicate:predicate];
    */
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}


@end