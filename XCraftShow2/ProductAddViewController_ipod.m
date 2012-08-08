//
//  ProductAddViewController_ipod.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductAddViewController_ipod.h"
#import "ProductPriceViewController.h"
#import "Product.h"
#import "Utilities.h"


@interface ProductAddViewController_ipod ()
- (NSString*)removeDollarSign:(NSString*)price;
@end


@implementation ProductAddViewController_ipod

@synthesize unitCost, quantity, name, defaultCost;
@synthesize managedObjectContext,selectedProduct;

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
    }
}

-(void) viewDidAppear:(BOOL)animated {
    
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
    
    ProductPriceViewController* ppvc = [[ProductPriceViewController alloc] initWithNibName:@"ProductPriceViewController" bundle:nil];
    ppvc.prevPriceLabel = (UIButton*) sender;
    [self presentModalViewController:ppvc animated:YES];
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
        product.unitCost = [formatter numberFromString:[self removeDollarSign:self.unitCost.titleLabel.text]];
        product.defaultCost = [formatter numberFromString:[self removeDollarSign:self.defaultCost.titleLabel.text]];
        product.image = 0;
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
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (NSString*)removeDollarSign:(NSString*)price; {
    if (price != nil && price.length > 0 && [price characterAtIndex:0] == '$') {
        price = [price substringFromIndex:1];
    }
    
    return price;
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
    // newImage is a UIImage do not try to use a UIImageView
    //self.locationPicture.contentMode = UIViewContentModeScaleAspectFit;
    //self.locationPicture.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
	// Save the image.
    //[DataManager saveImage:self.locationPicture.image];
    
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

@end
