//
//  ShowTableViewController.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowTableViewController.h"
#import "DataManager.h"
#import "ShowAddViewController.h"
#import "ShowAddViewController_ipod.h"
#import "CustomShowCell.h"
#import "Show.h"
#import "Sale.h"
#import "Product.h"
#import "SellViewController.h"
#import "SellViewController_ipod.h"
#import "Utilities.h"

static NSString *CellIdentifier = @"Normal Cell";

@implementation ShowTableViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;

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

    } 
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row+1>numberObjects) {
        
    } else {
        UIViewController* detailView;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            SellViewController_ipod *tempView = [[SellViewController_ipod alloc] 
                                              initWithNibName:@"SellViewController_ipod" bundle:nil];
            tempView.managedObjectContext = self.managedObjectContext;
            tempView.title = @"Sales";
            tempView.show = (Show*)[self.fetchedResultsController objectAtIndexPath:indexPath];
            detailView = tempView;
        } else {
            SellViewController *tempView = [[SellViewController alloc] 
                                              initWithNibName:@"SellViewController" bundle:nil];
            tempView.managedObjectContext = self.managedObjectContext;
            tempView.title = @"Sales";
            tempView.show = (Show*)[self.fetchedResultsController objectAtIndexPath:indexPath];
            detailView = tempView;
        }
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
    UIViewController* addView;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        ShowAddViewController_ipod* tempView = [[ShowAddViewController_ipod alloc] 
                   initWithNibName:@"ShowAddViewController_ipod" bundle:nil];
        tempView.managedObjectContext = self.managedObjectContext;
        addView = tempView;
    } else {
        ShowAddViewController* tempView = [[ShowAddViewController alloc] 
                                                initWithNibName:@"ShowAddViewController" bundle:nil];
        tempView.managedObjectContext = self.managedObjectContext;
        addView = tempView;
    }
    
    // 
    // Pass the selected object to the new view controller.
    //
    [self.navigationController pushViewController:addView animated:YES];
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
    // The where clause
    //
    
    /*
     if(self.searchBar.text!=nil) {
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"din contains[cd] %@",self.searchBar.text];
     [fetchRequest setPredicate:predicate];
     }
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *dateString = [dateFormatter stringFromDate:show.date];
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

@end