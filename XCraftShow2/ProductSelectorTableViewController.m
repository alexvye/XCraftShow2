//
//  ProductSelectorTableViewController.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductSelectorTableViewController.h"
#import "Product.h"

@implementation ProductSelectorTableViewController

@synthesize managedObjectContext;
@synthesize selProduct;

NSArray* products;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    self.selProduct = nil;

    //
    // setup the product list
    //
    products = [self getProducts];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(products.count < 8) {
        return 8; 
    } else {
        return products.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    //
    // Data section
    //
    UITableViewCell* cell;
    
    if(indexPath.row+1>products.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] 
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    } else {
        
        cell = (CustomProductCell*) [self.tableView dequeueReusableCellWithIdentifier:CustomProductCellIdentifier];
        if (cell == nil) {
            cell = [[CustomProductCell alloc] initWithFrame:CGRectZero reuseIdentifier:CustomProductCellIdentifier];
        }    
        //
        // Configure the cell...
        //
        [self configureCell:(CustomProductCell*)cell atIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < products.count) {
    //
    // Set the selected product
    //
        self.selProduct = [products objectAtIndex:indexPath.row];
    
    //
    // Pop view
    //
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

- (NSArray*)getProducts
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    [request setEntity:entityDesc];
    
    
    NSError *error;
    
    return [self.managedObjectContext executeFetchRequest:request error:&error];
}

- (void)configureCell:(CustomProductCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    Product* product = (Product*) [products objectAtIndex:indexPath.row];
    cell.productNameLabel.text = product.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *dateString = [dateFormatter stringFromDate:product.createdDate];
    cell.productDateLabel.text = [NSString stringWithFormat:@"Updated: %@", dateString];
    
    [[cell productImage] setImage:[UIImage imageNamed:@"no-img.jpeg"]];
    
    [[cell quantityTextField] setText:[NSString stringWithFormat:@"%d",product.quantity.intValue]];
}

@end
