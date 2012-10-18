//
//  SaleViewController_ipod.m
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-14.
//
//

#define PRICE_TEXT_FIELD 2
#define QUANTITY_PRICE_FIELD 1

#import "SaleViewController_ipod.h"
#import "Sale.h"
#import "State.h"
#import "Product.h"
#import "Utilities.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SaleViewController_ipod ()

@end

@implementation SaleViewController_ipod

@synthesize managedObjectContext;
@synthesize quantity;
@synthesize priceTextField,productImage;
@synthesize selectedProductLabel;
@synthesize show;
@synthesize tap;
@synthesize editedSale;
@synthesize prodView;

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
    [[State instance] clear];
    
    //
    // first time in, set the selected product to nil
    //

    if(prodView == nil) {
        prodView = [[ProductTableViewController alloc]
                    initWithNibName:@"ProductTableViewController" bundle:nil];
        prodView.managedObjectContext = self.managedObjectContext;
    }
    //
    // if being edited, set ui
    //
    if(editedSale!= nil) {
        Sale* sale = (Sale*)self.editedSale;
        self.selectedProductLabel.text = sale.productRel.name;
        self.priceTextField.text = [Utilities formatAsCurrency:sale.amount];
        self.quantity.text = [Utilities formatAsDecimal:sale.quantity];
        [State instance].selectedProduct = sale.productRel;
    }
}

- (void)viewWillAppear:(BOOL)animated {

    Product* product = [State instance].selectedProduct;
    if(product != nil) {
        self.selectedProductLabel.text = product.name;
        self.productImage.image = [[UIImage alloc] initWithData:product.image];
        self.priceTextField.text = [Utilities formatAsCurrency:product.defaultCost];
        self.quantity.text = @"1";
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if(textField.tag == QUANTITY_PRICE_FIELD) {
        if([State instance].selectedProduct != nil) {
            NSNumber* saleQantity = [NUMBER_FORMATTER numberFromString:textField.text];
            float defaultPrice = [State instance].selectedProduct.defaultCost.floatValue;
            NSNumber* salePrice = [NSNumber numberWithDouble:(saleQantity.intValue * defaultPrice)];
            self.priceTextField.text = [Utilities formatAsCurrency:salePrice];
        }
    } else {
        self.priceTextField.text = [NSString stringWithFormat:@"$%@",textField.text];
    }
    //
    // dismiss keyboard
    //
    [self.quantity resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.view removeGestureRecognizer:self.tap];
}

-(void)dismissKeyboard {
    [self.quantity resignFirstResponder];
    [self.view removeGestureRecognizer:self.tap];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)cancelSale:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [[State instance] clear];
//    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveSale:(id)sender {
    //
    // If you are coming from "edit sale", you will pass, otherwise you need to
    // select a product
    //
    if([State instance].selectedProduct == nil && self.editedSale == nil) {
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
        // Create/set sale oject
        //
        Sale* sale;
        
        //
        // create new sale and add to show if we are not editing an exiting one
        //
        if(self.editedSale == nil) {
            sale = (Sale*) [NSEntityDescription insertNewObjectForEntityForName:@"Sale" inManagedObjectContext:self.managedObjectContext];
            [self.show addSaleRelObject:sale];
            
        } else {
            sale = (Sale*) self.editedSale;
        }
        Product* product = [State instance].selectedProduct;
        sale.quantity = [NUMBER_FORMATTER numberFromString:self.quantity.text];
        //
        // Only decrement the quantity if it is not zero
        //
        if(product.quantity.doubleValue > 0.0) {
            product.quantity = [NSNumber numberWithDouble:(product.quantity.doubleValue - sale.quantity.doubleValue)];
        }
        sale.productRel = product;
        sale.amount = [CURRENCY_FORMATTER numberFromString:self.priceTextField.text];
        sale.date = self.show.date;
    
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
        [[State instance] clear];
        [self dismissModalViewControllerAnimated:YES];
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
    [self presentModalViewController:prodView animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}



@end
