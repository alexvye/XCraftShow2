//
//  SalesTableViewController.m
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-12.
//
//

#import "SalesTableViewController.h"
#import "SaleViewController_ipod.h"
#import "Show.h"
#import "Sale.h"
#import "Product.h"

@interface SalesTableViewController ()

@end

@implementation SalesTableViewController

@synthesize managedObjectContext;
@synthesize eventId;

Show* show;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // get show
    //
    show = [self showForEvent:eventId];
    
    //
    // Button for adding Shows
    //
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSale:)];
	self.navigationItem.rightBarButtonItem = plusButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self turnOffEditing];
    if(self.tableView != nil) {
        [self.tableView reloadData];
    }
    
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(show.saleRel.count < 8) {
        return 8;
    } else {
        return show.saleRel.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *EmptyCellIdentifier = @"EmptyCell";
    
    UITableViewCell* cell;
    
    if(indexPath.row+1 > show.saleRel.count) { // using empty filled rows, basically a no-op
        cell = [tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
        }
    } else {
        cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        Sale* sale = (Sale*)[[show.saleRel.objectEnumerator allObjects] objectAtIndex:indexPath.row];
        cell.textLabel.text = sale.productRel.name;
        //cell.detailTextLabel.text = @"detailedtext";
        //cell.imageView.image = [UIImage imageNamed:@"no-img.png"];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

-(Show*)showForEvent:(NSString*)eventIdentifier {
    if(eventIdentifier == nil) {
        return nil;
    }
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Show" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventId contains[cd] %@",eventIdentifier];
    [request setPredicate:predicate];
    
    
    NSError *error;
    
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(result.count == 0) {
        return nil;
    } else {
        return [result objectAtIndex:0];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(IBAction) addSale: (UIButton*) aButton {
    SaleViewController_ipod* detailView;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        detailView = [[SaleViewController_ipod alloc]
                      initWithNibName:@"SaleViewController_ipod" bundle:nil];
    } else {
        detailView = [[SaleViewController_ipod alloc]
                      initWithNibName:@"SaleViewController_ipod" bundle:nil];
    }
 
	//
	// Pass the selected object to the new view controller.
	//
    detailView.managedObjectContext = self.managedObjectContext;

    detailView.eventId = self.eventId;
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
