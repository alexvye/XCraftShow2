//
//  SalesTableViewController.m
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-12.
//
//
#define MIN_SALE_ROWS 8 // always populate table with 8 rows to avoid the ugly empty table look
#define INFO_SECTION 0

#import "SalesTableViewController.h"
#import "SaleViewController_ipod.h"
#import "Sale.h"
#import "Product.h"
#import "Utilities.h"

@interface SalesTableViewController ()

@end

@implementation SalesTableViewController
@synthesize salesTableView, managedObjectContext, show;

float rowHeight;
float primaryFontSize;
float detailedFontSize;
/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        rowHeight = 44.0;
        primaryFontSize = 18.0;
        detailedFontSize = 14.0;
    } else {
        rowHeight = 99.0;
        primaryFontSize = 36.0;
        detailedFontSize = 24.0;
    }
    self.salesTableView.rowHeight = rowHeight;
    //
    // Button for adding Shows
    //
    //
	// Edit button for reordering of array
	//
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(turnOnEditing)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self turnOffEditing];
    if(self.salesTableView != nil) {
        [self.salesTableView reloadData];
    }
}

- (void)turnOnEditing {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(turnOffEditing)];
    [self.salesTableView setEditing:YES animated:YES];
}

- (void)turnOffEditing {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(turnOnEditing)];
    [self.salesTableView setEditing:NO animated:YES];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == INFO_SECTION) {
        return 1;
    } else {
        if(self.show.saleRel.count < MIN_SALE_ROWS) {
            if(![[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                return 7;
            } else {
                return MIN_SALE_ROWS;
            }
        } else {
            return self.show.saleRel.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == INFO_SECTION) {
        static NSString* HeaderCellIdentifier = @"HeaderCell";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderCellIdentifier];
        }
        
        //
        // calculate cumulative sales
        //
        NSString* headerString = [NSString stringWithFormat:@"%d sales for a total of %@",self.show.saleRel.count, [Utilities formatAsCurrency:[self cumulativeSales]]];
        
        cell.textLabel.text = headerString;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:primaryFontSize];

        return cell;
    } else {
        static NSString *EmptyCellIdentifier = @"EmptyCell";

        if(indexPath.row+1 > self.show.saleRel.count) { // using empty filled rows, basically a no-op
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
            }
            return cell;
        } else {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
            }
            Sale* sale = (Sale*)[[self.show.saleRel.objectEnumerator allObjects] objectAtIndex:indexPath.row];
            cell.textLabel.text = sale.productRel.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Quantity = %@, Total = %@", sale.quantity, [Utilities formatAsCurrency:sale.amount]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.textColor = [UIColor colorWithRed:154.0/255.0 green:14.0/255.0 blue:2.0/255.0 alpha:1];
            cell.textLabel.font = [UIFont systemFontOfSize:primaryFontSize];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:detailedFontSize];
            
            // begin scale image
            CGSize destinationSize = CGSizeMake(80, 80);
            
            UIGraphicsBeginImageContext(destinationSize);
            [[UIImage imageWithData:sale.productRel.image] drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // end scale image
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            return cell;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == INFO_SECTION) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = FALSE;
        return;
    }
    
    if(indexPath.row < show.saleRel.allObjects.count) {

    //
    // push the view controller
    //
        SaleViewController_ipod* detailView;
            
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            detailView = [[SaleViewController_ipod alloc]
                      initWithNibName:@"SaleViewController_ipod" bundle:nil];
        } else {
            detailView = [[SaleViewController_ipod alloc]
                      initWithNibName:@"SaleViewController_ipad" bundle:nil];
        }

        //
        // Pass the selected object to the new view controller.
        //
        detailView.managedObjectContext = self.managedObjectContext;
        detailView.show = self.show;
        detailView.editedSale = [self.show.saleRel.allObjects objectAtIndex:indexPath.row];
        [self presentModalViewController:detailView animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row +1 > [self.show.saleRel allObjects].count || indexPath.section == 0) {
        return false;
    } else {
        return true;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        [self.show removeSaleRelObject:[[self.show.saleRel allObjects] objectAtIndex:indexPath.row]];
        
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
        [self.salesTableView endUpdates];
        [self.salesTableView reloadData];
    }
}

-(IBAction) addSale:(id)sender{
    SaleViewController_ipod* detailView;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        detailView = [[SaleViewController_ipod alloc]
                      initWithNibName:@"SaleViewController_ipod" bundle:nil];
    } else {
        detailView = [[SaleViewController_ipod alloc]
                      initWithNibName:@"SaleViewController_ipad" bundle:nil];
    }
 
	//
	// Pass the selected object to the new view controller.
	//
    detailView.managedObjectContext = self.managedObjectContext;
    detailView.show = self.show;
    detailView.editedSale = nil;
    [self presentModalViewController:detailView animated:YES];
}

- (NSNumber*)cumulativeSales {
    double sum = 0.0;
    for(Sale* sale in self.show.saleRel) {
        sum += [sale.amount doubleValue];
    }
    return [NSNumber numberWithDouble:sum];
}

-(IBAction)openMail:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        NSString* subjectString = [NSString stringWithFormat:@"Export for %@ on %@",
                                   self.show.name, [DATE_FORMATTER stringFromDate:self.show.date]];
        [mailer setSubject:subjectString];
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSString *val = nil;
        
        if (standardUserDefaults)
            val = [standardUserDefaults stringForKey:@"export-email"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:val, nil];
        [mailer setToRecipients:toRecipients];
        
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
    for(Sale* sale in self.show.saleRel) {
        Product* product = sale.productRel;
        
        NSString *dateString = [DATE_FORMATTER stringFromDate:sale.date];
        body = [body stringByAppendingString:[NSString stringWithFormat:
                                              @"%@ %@ %@ %@\n",
                                              [Utilities truncateString:product.name:10],
                                              dateString,
                                              [Utilities formatAsCurrency:sale.amount],
                                              [Utilities formatAsDecimal:sale.quantity]]];
    }
    
    return body;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:true];
}

@end
