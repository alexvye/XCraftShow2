//
//  SaleViewController_ipod.m
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-14.
//
//

#import "SaleViewController_ipod.h"
#import "Sale.h"
#import "State.h"
#import "Product.h"
#import "Utilities.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ProductPriceViewController.h"

@interface SaleViewController_ipod ()

@end

@implementation SaleViewController_ipod

@synthesize managedObjectContext;
@synthesize quantity;
@synthesize price,priceButton;
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
        self.priceButton.titleLabel.text = [Utilities formatAsCurrency:sale.amount];
        self.quantity.text = [Utilities formatAsDecimal:sale.quantity];
        [[State instance] setValue:sale.quantity forKey:SALE_PRICE];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //
    // Only one text field, quantity, set the price
    // to be quantity * default cost
    //
    NSNumber* saleQantity = [NUMBER_FORMATTER numberFromString:textField.text];
    double defaultPrice = [[[State instance].mem objectForKey:DEFAULT_PRICE] doubleValue];
    NSNumber* salePrice = [NSNumber numberWithDouble:(saleQantity.intValue * defaultPrice)];
    self.priceButton.titleLabel.text = [Utilities formatAsCurrency:salePrice];
    [self.quantity resignFirstResponder];
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

- (void)viewWillAppear:(BOOL)animated {
    Product* selectedProduct = [[State instance].mem objectForKey:SELECTED_PRODUCT];
    NSNumber* salePrice = [[State instance].mem objectForKey:SALE_PRICE];
    
    if(selectedProduct != nil) {
        self.selectedProductLabel.text = selectedProduct.name;
        self.quantity.text = [NSString stringWithFormat:@"%d",1];
        [self.priceButton setTitle:[Utilities formatAsCurrency:selectedProduct.defaultCost] forState:UIControlStateNormal];
    }
    
    if(salePrice != nil) {
       [self.priceButton setTitle:[Utilities formatAsCurrency:salePrice] forState:UIControlStateNormal];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)cancelSale:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveSale:(id)sender {
    //
    // If you are coming from "edit sale", you will pass, otherwise you need to
    // select a product
    //
    if([[State instance].mem objectForKey:SELECTED_PRODUCT] == nil && self.editedSale == nil) {
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
        
        if([[State instance].mem objectForKey:SELECTED_PRODUCT] != nil) {
            sale.productRel = [[State instance].mem objectForKey:SELECTED_PRODUCT];
        }
        
        sale.quantity = [NUMBER_FORMATTER numberFromString:self.quantity.text];
        sale.amount = [[State instance].mem objectForKey:SALE_PRICE];
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

- (IBAction)openPricePicker:(id)sender {
    [self resignButton:sender];
    
    ProductPriceViewController* ppvc = [[ProductPriceViewController alloc] initWithNibName:@"ProductPriceViewController" bundle:nil];
    ppvc.priceKey = SALE_PRICE;
    [self presentModalViewController:ppvc animated:YES];
}

- (IBAction)resignButton:(id)sender {
   [self.priceButton resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == kDollars) {
        return 1000;
    }
    
    return 100;
}

@end
