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
#import <MessageUI/MFMailComposeViewController.h>

@interface SalesTableViewController ()

@end

@implementation SalesTableViewController
@synthesize managedObjectContext, show;

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
            return MIN_SALE_ROWS;
        } else {
            return self.show.saleRel.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *EmptyCellIdentifier = @"EmptyCell";
    if(indexPath.section == INFO_SECTION) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeaderCell"];
        }
        
        //
        // calculate cumulative sales
        //
        NSString* headerString = [NSString stringWithFormat:@"Sales = %@",[Utilities formatAsCurrency:[self cumulativeSales]]];
        
        cell.textLabel.text = headerString;
        return cell;
    } else {
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
            return cell;
        }
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
    detailView.show = self.show;
    [self.navigationController pushViewController:detailView animated:YES];
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

@end
