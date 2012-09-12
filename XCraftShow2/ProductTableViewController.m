//
//  ProductTableViewController.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define MIN_PRODUCT_ROWS 8 // always populate table with 8 rows to avoid the ugly empty table look

static NSString *CellIdentifier = @"Normal Cell";
static NSString *EmptyCellIdentifier = @"Empty Cell";

#import "ProductTableViewController.h"
#import "ProductAddViewController_ipod.h"
#import "Product.h"
#import "CustomProductCell.h"
#import "Utilities.h"

@implementation ProductTableViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize selecting, selProduct; // for reuse of this controller for selecting products

float rowHeight;
float titleFontSize;

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
    //
    // Set constants for different devices
    //
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        rowHeight = 44.0;
        titleFontSize = 12.0;
    } else {
        rowHeight = 99.0;
        titleFontSize = 15.0;
    }
    
    self.tableView.rowHeight = rowHeight;
    
    //
    // Don't draw buttons if coming from sell view controller
    //
    if(!self.selecting) {
    //
	// Edit button for reordering of array
	//
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(turnOnEditing)];
    
    //
    // Button for adding Products
    //
        UIBarButtonItem *plusButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProduct:)];
        self.navigationItem.leftBarButtonItem = plusButton;
    }
    //
    // for when we come from sell view controller
    //
    selProduct = nil;
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

    if([sectionInfo numberOfObjects] < MIN_PRODUCT_ROWS) {
        return MIN_PRODUCT_ROWS;
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
    
    if(indexPath.row+1>[sectionInfo numberOfObjects])  { // using empty filled rows, basically a no-op
        UITableViewCell* cell;cell = [tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] 
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
        }
        return cell;
        
    } else {
        static NSString* productCellStr = @"CustomProductCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:productCellStr];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:productCellStr];
        }
        
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];        
        Product* product = (Product*) managedObject;
        
        cell.textLabel.text = product.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Quantity: %d",product.quantity.intValue];
        cell.imageView.image = [[UIImage alloc] initWithData:product.image];
        
        if(!self.selecting) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        
        return cell;
    }
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
    if(indexPath.row+1 <= [sectionInfo numberOfObjects]) {
        
        
        //
        // if you came from sell view controller, select product and pop
        // if you are adding product (came from tab bar) push to editor
        //
        if(self.selecting) {
            self.selProduct = (Product*)[self.fetchedResultsController objectAtIndexPath:indexPath];
            NSLog(@"Selected product %@ costs %@",self.selProduct.name, self.selProduct.unitCost);
            [self.navigationController popViewControllerAnimated:TRUE];
            
        } else {
	//
	// push the view controller
	//
            ProductAddViewController_ipod* detailView;
    
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                detailView = [[ProductAddViewController_ipod alloc]
                                                   initWithNibName:@"ProductAddViewController_ipod" bundle:nil];
            } else {
                detailView = [[ProductAddViewController_ipod alloc]
                                              initWithNibName:@"ProductAddViewController" bundle:nil];
            }
            
            detailView.managedObjectContext = self.managedObjectContext;
            detailView.selectedProduct = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	//
	// Pass the selected object to the new view controller.
	//
            [self presentModalViewController:detailView animated:YES];
        }
    }
}

-(IBAction) addProduct: (UIButton*) aButton {
	//
	// push the view controller
	//
    ProductAddViewController_ipod* detailView;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        detailView = [[ProductAddViewController_ipod alloc] 
                                             initWithNibName:@"ProductAddViewController_ipod" bundle:nil];
    } else {
        detailView = [[ProductAddViewController_ipod alloc] 
                                             initWithNibName:@"ProductAddViewController" bundle:nil];
    }
    
    detailView.managedObjectContext = self.managedObjectContext;
    detailView.selectedProduct = nil;
	
	//
	// Pass the selected object to the new view controller.
	//
    [self presentModalViewController:detailView animated:YES];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:5]; //default was 20
    
    // Edit the sort key as appropriate.
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
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
    [newManagedObject setValue:@"Product name" forKey:@"name"];
    
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

@end