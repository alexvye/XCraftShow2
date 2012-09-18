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
        //
        // iPad has price in picker on current screen/iphone has it on button
        //
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
            int dollar = self.price.longValue/100;
            int cent = (self.price.longValue-dollar)*100;
                
            [self.picker selectRow:dollar inComponent:0 animated:NO];
            [self.picker reloadComponent:0];
            [self.picker selectRow:cent inComponent:1 animated:NO];
            [self.picker reloadComponent:1];
        }
    }
}


/*
 if (self.prevPriceLabel != nil) {
 NSString* tmpPrice = self.price;
 if (tmpPrice != nil && tmpPrice.length > 0 && [tmpPrice characterAtIndex:0] == '$') {
 tmpPrice = [tmpPrice substringFromIndex:1];
 }
 NSArray* nums = [tmpPrice componentsSeparatedByString: @"."];
 if (nums != nil && [nums count] >= 2) {
 int dollar = [[nums objectAtIndex:0] intValue];
 int cent = [[nums objectAtIndex:1] intValue];
 
 [self.picker selectRow:dollar inComponent:0 animated:NO];
 [self.picker reloadComponent:0];
 [self.picker selectRow:cent inComponent:1 animated:NO];
 [self.picker reloadComponent:1];
 }
 }
 */
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
    NSNumber* saleQqantity = [NUMBER_FORMATTER numberFromString:textField.text];
    NSNumber* salePrice = [NSNumber numberWithLong:(saleQqantity.intValue * self.prodView.selProduct.defaultCost.longValue)];
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
    if(self.prodView.selProduct != nil) {
        self.selectedProductLabel.text = self.prodView.selProduct.name;
        self.quantity.text = [NSString stringWithFormat:@"%d",1];
        NSLog(@"Price should be %@", self.prodView.selProduct.unitCost);
        [self.priceButton setTitle:[Utilities formatAsCurrency:self.prodView.selProduct.defaultCost] forState:UIControlStateNormal] ;
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
    if(self.prodView.selProduct == nil && self.editedSale == nil) {
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
            
        }
        
        if(self.prodView != nil) {
            sale.productRel = (Product*) self.prodView.selProduct;
        }
        sale.quantity = [NUMBER_FORMATTER numberFromString:self.quantity.text];
        
        //
        // iPad has price in picker on current screen/iphone has it on button
        //
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            sale.amount = [CURRENCY_FORMATTER numberFromString:self.priceButton.titleLabel.text];
        } else {
            sale.amount = self.price;

        }
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
        [self dismissModalViewControllerAnimated:YES];
//        [self.navigationController popViewControllerAnimated:true];
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
//    [self.navigationController pushViewController:prodView animated:YES];
}

- (IBAction)openPricePicker:(id)sender {
    [self resignButton:sender];
    
    ProductPriceViewController* ppvc = [[ProductPriceViewController alloc] initWithNibName:@"ProductPriceViewController" bundle:nil];
    ppvc.prevPriceLabel = (UIButton*) sender;
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

#pragma mark - UIPickerViewDelegate methods
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == kDollars) {
        //        if (row == [pickerView selectedRowInComponent:component]) {
        return [NSString stringWithFormat:@"   %d", row];
        //        } else {
        //            return [NSString stringWithFormat:@"%d", row];
        //        }
    }
    
    return [NSString stringWithFormat:@"%02d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger dollarValue = [pickerView selectedRowInComponent:kDollars];
    NSInteger centValue = [pickerView selectedRowInComponent:KCents];
    self.price = [NSNumber numberWithLong:(dollarValue + centValue/100)];
    //    [pickerView reloadComponent:kDollars];
}

@end
