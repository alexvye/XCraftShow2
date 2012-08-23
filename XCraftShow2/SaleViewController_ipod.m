//
//  SaleViewController_ipod.m
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-14.
//
//

#import "SaleViewController_ipod.h"
#import "Sale.h"
#import "Product.h"
#import "Utilities.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ProductPriceViewController.h"
#import "ProductTableViewController.h"
#import <EventKit/EventKit.h>

@interface SaleViewController_ipod ()

@end

@implementation SaleViewController_ipod

@synthesize selectedProduct;
@synthesize managedObjectContext;
@synthesize eventId;
@synthesize quantity;
@synthesize price;
@synthesize selectedProductLabel;

ProductTableViewController* prodView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //
    // first time in, set the selected product to nil
    //
    selectedProduct = nil;
    
    if(prodView == nil) {
        prodView = [[ProductTableViewController alloc]
                    initWithNibName:@"ProductTableViewController" bundle:nil];
        prodView.managedObjectContext = self.managedObjectContext;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    selectedProduct = prodView.selProduct;
    if(selectedProduct != nil) {
        self.selectedProductLabel.text = prodView.selProduct.name;
        self.quantity.text = [NSString stringWithFormat:@"%d",1];
        Product* product = (Product*) selectedProduct;
        self.price.text = [Utilities formatAsCurrency:product.defaultCost];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        // Get the show for event for the selected row
        //
        Show* thisShow = [self showForEvent:eventId];
        
        //
        // Create/set showinfo oject
        //
        Sale* sale = (Sale*) [NSEntityDescription insertNewObjectForEntityForName:@"Sale" inManagedObjectContext:self.managedObjectContext];
        
        sale.quantity = [NUMBER_FORMATTER numberFromString:self.quantity.text];
        sale.amount = [CURRENCY_FORMATTER numberFromString:self.price.text];
        sale.date = [NSDate date];
        sale.productRel = (Product*) selectedProduct;
        [thisShow addSaleRelObject:sale];
        
        //
        // Save
        //
        
        NSError *error;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Error %@", [error localizedDescription]);
        }
        
        //
        // cash register sound
        //
        [self playSound];
        
        //
        // go back to sales table
        //
        [self.navigationController popViewControllerAnimated:true];
    }
}

-(Show*)showForEvent:(NSString*)eventIdentifier {
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

-(void)playSound {
    SystemSoundID soundID;
    NSString *soundFile = [[NSBundle mainBundle] pathForResource: @"cash-register" ofType: @"aiff"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:soundFile], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

-(IBAction) selectProduct:(id)sender {
    //
    // Pass the selected object to the new view controller.
    //
    prodView.selecting = TRUE;
    [self.navigationController pushViewController:prodView animated:YES];
}

- (IBAction)openPricePicker:(id)sender {
    [self resignButton:sender];
    
    ProductPriceViewController* ppvc = [[ProductPriceViewController alloc] initWithNibName:@"ProductPriceViewController" bundle:nil];
    ppvc.prevPriceLabel = (UIButton*) sender;
    [self presentModalViewController:ppvc animated:YES];
}

- (IBAction)resignButton:(id)sender {
    // [self. resignFirstResponder];
}
@end
