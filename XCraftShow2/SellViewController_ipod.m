//
//  SellViewController_ipod.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SellViewController_ipod.h"
#import "Product.h"
#import "Sale.h"
#import "CustomSaleCell.h"
#import "Utilities.h"
#import "ProductSelectorTableViewController.h"
#import "ShowAddViewController_ipod.h"

static NSString *CellIdentifier = @"Normal Cell";

@implementation SellViewController_ipod

NSArray* products;
Product* selectedProduct;
NSArray* sales;
NSString* headerString;
NSString* dateString;
UILabel* headerLabel;

@synthesize showDate, showName, price, productName, sellButton, salesTable, quantity, managedObjectContext;
@synthesize show;

ProductSelectorTableViewController* prodView;

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
    // short rows
    //
    self.salesTable.rowHeight = 22.0;
    
    //
    // first time in, set the selected product to nil
    //
    selectedProduct = nil;
    
    if(prodView == nil) {
        prodView = [[ProductSelectorTableViewController alloc] 
                initWithNibName:@"ProductSelectorTableViewController" bundle:nil];
        prodView.managedObjectContext = self.managedObjectContext;
    }
    
    //
    // data for sales
    //
    sales = [self sortedSales:[self.show.saleRel allObjects]];
    
    //
	// Edit button for reordering of array
	//
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(turnOnEditing)];
    
    //
    // setup sales table header
    //
    
    // header
    headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.textColor = [UIColor blackColor];
    dateString = [DATE_FORMATTER stringFromDate:show.date];
    headerString = [NSString stringWithFormat:@"%@, %@ = %@",show.name,dateString,[Utilities formatAsCurrency:[self cumulativeSales]]];
    
    headerLabel.text = headerString; 
    self.salesTable.tableHeaderView = headerLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    if(prodView.selProduct != nil) {
        self.productName.text = prodView.selProduct.name;
        selectedProduct = prodView.selProduct;
        self.quantity.text = [Utilities formatAsDecimal:[NSNumber numberWithInt:1]];
        self.price.text = [Utilities formatAsCurrency:selectedProduct.defaultCost]; 
    }
}

- (void)turnOnEditing {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(turnOffEditing)];
    [self.salesTable setEditing:YES animated:YES];
}

- (void)turnOffEditing {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(turnOnEditing)];
    [self.salesTable setEditing:NO animated:YES];
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
	return YES;
}

#pragma mark - textview delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    double amount = selectedProduct.defaultCost.doubleValue*[CURRENCY_FORMATTER numberFromString:self.quantity.text].doubleValue;
    
    if(textField == quantity) {
        self.price.text = [Utilities formatAsCurrency:[NSNumber numberWithDouble:amount]]; 
    }
    
    [textField resignFirstResponder];
    return TRUE;
}

#pragma mark - product picker delegate calls

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == 0) {
        return @"< No selection>";
    } else {
        Product* product = (Product*) [products objectAtIndex:row-1];
        return product.name;
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [products count]+1;
}

- (NSArray*)getProducts
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    [request setEntity:entityDesc];
    
    
    NSError *error;
    
    return [self.managedObjectContext executeFetchRequest:request error:&error];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(row == 0) {
        selectedProduct = nil;
    } else {
        selectedProduct = [products objectAtIndex:row-1];
        self.quantity.text = [Utilities formatAsDecimal:[NSNumber numberWithInt:1]];
        self.price.text = [Utilities formatAsCurrency:selectedProduct.defaultCost]; 
    }
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([sales count] >= 11) {
        return [sales count];  
    } else {
        return 11;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    // Data section
    //
    UITableViewCell* cell;
    
    if(indexPath.row+1>[sales count]) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] 
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    } else {
        cell = (CustomSaleCell*) [self.salesTable dequeueReusableCellWithIdentifier:CustomSaleCellIdentifier];
        if (cell == nil) {
            cell = [[CustomSaleCell alloc] initWithFrame:CGRectZero reuseIdentifier:CustomSaleCellIdentifier];
        }
        
        //
        // Configure the cell...
        //
        [self configureCell:(CustomSaleCell*)cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row +1 > [sales count]) {
        return false;
    } else {
        return true;
    } 
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Sale* sale = [sales objectAtIndex:indexPath.row];
        [show removeSaleRelObject:sale];
        
        [self.salesTable reloadData];
        sales = [self sortedSales:[self.show.saleRel allObjects]];
        
        // Delete the managed object for the given index path
        [self.managedObjectContext deleteObject:[sales objectAtIndex:indexPath.row]];
        
        // Save the context.
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        sales = [self sortedSales:[self.show.saleRel allObjects]];
        [self.salesTable endUpdates];
        [self.salesTable reloadData];
        
        sales = [self sortedSales:[self.show.saleRel allObjects]];
        
        headerString = [NSString stringWithFormat:@"%@, %@ = %@",show.name,dateString,[Utilities formatAsCurrency:[self cumulativeSales]]];
        headerLabel.text = headerString; 
        self.salesTable.tableHeaderView = headerLabel;
    } 
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Fetched results controller

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    [self.salesTable endUpdates];
}

- (void)configureCell:(CustomSaleCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [sales objectAtIndex:indexPath.row];
    
    Sale* sale = (Sale*) managedObject;
    Product* product = sale.productRel;
    cell.productNameLabel.text = product.name;
    
    NSString *dateString = [DATE_FORMATTER stringFromDate:sale.date];
    cell.saleDateLabel.text = dateString;
    cell.saleAmountLabel.text = [Utilities formatAsCurrency:sale.amount];
    cell.saleQuantityLabel.text = [Utilities formatAsDecimal:sale.quantity];
}

- (IBAction)saveSale:(id)sender {
    if(selectedProduct == nil) {
        //
        // alert the user that they need to select a product
        //
        NSString *message = @"Please select a product to sell....";
        
        UIAlertView *alertDialog = [[UIAlertView alloc]
                                    initWithTitle:@"Warning"
                                    message:message
                                    delegate:nil
                                    cancelButtonTitle:@"Ok"
                                    otherButtonTitles:nil];
        [alertDialog show];
        
    } else {
        //
        // Create/set showinfo oject
        //
        Sale* sale = (Sale*) [NSEntityDescription insertNewObjectForEntityForName:@"Sale" inManagedObjectContext:self.managedObjectContext];
        
        sale.quantity = [NUMBER_FORMATTER numberFromString:self.quantity.text];

        sale.amount = [CURRENCY_FORMATTER numberFromString:self.price.text];
        
        sale.date = [NSDate date];
        sale.productRel = selectedProduct;
        [show addSaleRelObject:sale];
        
        //
        // Save
        //
        
        NSError *error;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Error %@", [error localizedDescription]);
        }
        
        //
        // reload table
        //
        sales = [self sortedSales:[self.show.saleRel allObjects]];
        headerString = [NSString stringWithFormat:@"%@, %@ = %@",show.name,dateString,[Utilities formatAsCurrency:[self cumulativeSales]]];
        headerLabel.text = headerString; 
        self.salesTable.tableHeaderView = headerLabel;
        
        [self.salesTable reloadData];
        
        //
        // cash register sound
        //
        //[self playSound];
    }
}

-(NSArray*)sortedSales:(NSArray*)_sales {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [_sales sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSNumber*)cumulativeSales {
    double sum = 0.0;
    for(Sale* sale in sales) {
        sum += [sale.amount doubleValue];
    }
    return [NSNumber numberWithDouble:sum];
}

-(void)playSound {
    NSURL *soundFile;
    AVAudioPlayer *audioPlayer;
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"cash-register" ofType: @"aiff"];        
    soundFile = [NSURL fileURLWithPath:soundFilePath];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:nil];
    [audioPlayer setDelegate:self];
    [audioPlayer play];                                 
}

-(IBAction) selectProduct:(id)sender {
    // 
    // Pass the selected object to the new view controller.
    //
    [self.navigationController pushViewController:prodView animated:YES];
}

-(IBAction) editProduct:(id)sender {
	//
	// push the view controller
	//
    ShowAddViewController_ipod* addView = [[ShowAddViewController_ipod alloc] 
                                                initWithNibName:@"ShowAddViewController_ipod" bundle:nil];
    addView.managedObjectContext = self.managedObjectContext;
    addView.selectedShow = self.show;
    
    // 
    // Pass the selected object to the new view controller.
    //
    [self.navigationController pushViewController:addView animated:YES];
}

-(IBAction)openMail:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        NSString* subjectString = [NSString stringWithFormat:@"Export for %@ on %@",
                                   self.show.name, [DATE_FORMATTER stringFromDate:self.show.date]];
        [mailer setSubject:subjectString];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
        [mailer setToRecipients:toRecipients];
        
        UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"]; 
        
        NSString *emailBody = [self generateExportBody];
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:mailer animated:YES];  
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


-(NSString*) generateExportBody {    
    //
    // generate export
    //
    NSString* body = @"============================\n";
    body = [body stringByAppendingString:self.show.name];
    body = [body stringByAppendingString:@"\n============================\n"];
    for(Sale* sale in sales) {
        Product* product = sale.productRel;

        NSString *dateString = [DATE_FORMATTER stringFromDate:sale.date];
        body = [body stringByAppendingString:[NSString stringWithFormat:
                                              @"%@ %@ %@ %@\n", product.name, dateString, [Utilities formatAsCurrency:sale.amount], [Utilities formatAsDecimal:sale.quantity]]];
    }
    
    return body;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

@end
