//
//  ProductAddViewController_ipod.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define UNIT_COST_TAG 1
#define DEFAULT_COST_TAG 2

#import "ProductAddViewController_ipod.h"
#import "ProductPriceViewController.h"
#import "Product.h"
#import "Utilities.h"
#import "State.h"

@interface ProductAddViewController_ipod ()
- (NSString*)removeDollarSign:(NSString*)price;
@end


@implementation ProductAddViewController_ipod

@synthesize unitCost, quantity, name, defaultCost;
@synthesize managedObjectContext,selectedProduct,image,productImageView;
@synthesize tap;

//
// for ipad ui
//
@synthesize popover;
//@synthesize price, prevPriceLabel,unitCostPicker,defaultCostCostPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *productImage = [UIImage imageNamed:@"no-img.jpeg"];
        self.image = UIImagePNGRepresentation(productImage);
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
    

    // Do any additional setup after loading the view from its nib.
    //
    // Create/set product oject
    //
    
    if(selectedProduct == nil) {
        self.name.text = @"";
        self.quantity.text = [Utilities formatAsDecimal:[NSNumber numberWithInt:0]];
    } else {
        Product* product = (Product*) self.selectedProduct;
        self.name.text = product.name;
        self.quantity.text = [Utilities formatAsDecimal:product.quantity];
        [self.unitCost setTitle:[Utilities formatAsCurrency:product.unitCost] forState:UIControlStateNormal];
        [self.defaultCost setTitle:[Utilities formatAsCurrency:product.defaultCost] forState:UIControlStateNormal];
        self.productImageView.image = [[UIImage alloc] initWithData:product.image];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    /*
    self.tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
     */
}

-(void)dismissKeyboard {
    [self.name resignFirstResponder];
    [self.quantity resignFirstResponder];
    //[self.view removeGestureRecognizer:self.tap];
}

-(void) viewDidAppear:(BOOL)animated {
    
}

- (void) viewWillAppear:(BOOL)animated  {
    NSNumber* defaultPrice = [[State instance].mem objectForKey:DEFAULT_PRICE];
    if(defaultPrice == nil) {
        defaultPrice = [NSNumber numberWithDouble:0.00];
    }
    NSNumber* unitPrice = [[State instance].mem objectForKey:UNIT_COST];
    if(unitPrice == nil) {
        unitPrice = [NSNumber numberWithDouble:0.00];
    }
    
    self.defaultCost.titleLabel.text = [Utilities formatAsCurrency:defaultPrice];
    self.unitCost.titleLabel.text = [Utilities formatAsCurrency:unitPrice];
}


-(void)viewWillDisappear:(BOOL)animated {
    
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

- (BOOL) doesProductExist:(NSString*)_name 
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@",_name];
    [request setPredicate:predicate];
    
    
    NSError *error;
    
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(result.count == 0) {
        return FALSE;
    } else {
        return TRUE;
    }
}

- (IBAction)openPricePicker:(id)sender {
    [self resignButton:sender];
    
    UIButton* button = (UIButton*)sender;
    NSString* key;
    if(button.tag == UNIT_COST_TAG) {
        key = UNIT_COST;
    } else {
        key = DEFAULT_PRICE;
    }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        ProductPriceViewController* ppvc = [[ProductPriceViewController alloc] initWithNibName:@"ProductPriceViewController_iPad" bundle:nil];
        ppvc.priceKey = key;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:ppvc];
        self.popover.popoverContentSize = ppvc.view.frame.size;
       UIView* view = sender;
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        ProductPriceViewController* ppvc = [[ProductPriceViewController alloc] initWithNibName:@"ProductPriceViewController" bundle:nil];
        ppvc.priceKey = key;
       [self presentModalViewController:ppvc animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSNumber* defaultPrice = [[State instance].mem objectForKey:DEFAULT_PRICE];
    if(defaultPrice == nil) {
        defaultPrice = [NSNumber numberWithDouble:0.00];
    }
    NSNumber* unitPrice = [[State instance].mem objectForKey:UNIT_COST];
    if(unitPrice == nil) {
        unitPrice = [NSNumber numberWithDouble:0.00];
    }
    
    self.defaultCost.titleLabel.text = [Utilities formatAsCurrency:defaultPrice];
    self.unitCost.titleLabel.text = [Utilities formatAsCurrency:unitPrice];
}

- (IBAction)resignButton:(id)sender {
    [self.name resignFirstResponder];
    [self.quantity resignFirstResponder];
}

- (IBAction)cancelProduct:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) saveProduct: (UIButton*) aButton {
    //
    // Create/set product oject
    //
    Product* product;
    
    //
    // Check existing product names for duplicates
    // product names is an array of strings
    //
    if( (self.selectedProduct == nil && [self doesProductExist:self.name.text]) || [self.name.text isEqualToString:@""]) {
        
        //
        // alert the user that they need to select a product
        //
        NSString *message = @"Please enter a non-blank, unique product name.";
        
        UIAlertView *alertDialog = [[UIAlertView alloc]
                                    initWithTitle:@"Duplicate product name"
                                    message:message
                                    delegate:nil
                                    cancelButtonTitle:@"Ok"
                                    otherButtonTitles:nil];
        [alertDialog show];
    } else {
        
        if(self.selectedProduct == nil) { // adding new product
            product = (Product*) [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        } else { // editing existing one
            product = (Product*) self.selectedProduct;
        }
        
        product.name = self.name.text;
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        product.quantity = [formatter numberFromString:self.quantity.text];
        product.unitCost = [[State instance].mem objectForKey:UNIT_COST];
        product.defaultCost = [[State instance].mem objectForKey:DEFAULT_PRICE];
        product.image = self.image;

        product.createdDate = [NSDate date];
        
        //
        // Save
        //
        NSError *error;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Error %@", [error localizedDescription]);
        }
        
        //
        // Pop view
        //
        [[State instance] clear];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (NSString*)removeDollarSign:(NSString*)localPrice; {
    if (localPrice != nil && localPrice.length > 0 && [localPrice characterAtIndex:0] == '$') {
        localPrice = [localPrice substringFromIndex:1];
    }
    
    return localPrice;
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
	UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
	if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
		picker.delegate = self;
		picker.sourceType = sourceType;
		[self presentModalViewController:picker animated:YES];
	} else {
		// Display location services not available message.
		NSString *errorType = @"Camera Error";
		NSString *errorMsg = @"The camera is not available.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorType message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *productImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.image = UIImagePNGRepresentation(productImage);
    self.productImageView.image = productImage;
    
	[picker dismissModalViewControllerAnimated:YES];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved"
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
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
//    NSInteger dollarValue = [pickerView selectedRowInComponent:kDollars];
//    NSInteger centValue = [pickerView selectedRowInComponent:KCents];
//    self.price = [NSString stringWithFormat:@"$%d.%02d", dollarValue, centValue];
    //    [pickerView reloadComponent:kDollars];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
