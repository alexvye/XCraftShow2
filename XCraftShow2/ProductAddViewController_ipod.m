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
#import "Product.h"
#import "Utilities.h"
#import "State.h"


@implementation ProductAddViewController_ipod

@synthesize unitCostTextField, quantity, name, defaultPriceTextField;
@synthesize managedObjectContext,selectedProduct,productImageView;
@synthesize tap;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    if(self.selectedProduct == nil) {
        self.defaultPriceTextField.text = [Utilities formatAsCurrency:[NSNumber numberWithFloat:0.00]];
        self.unitCostTextField.text = [Utilities formatAsCurrency:[NSNumber numberWithFloat:0.00]];
        self.productImageView.image = [UIImage imageNamed:@"no-img.jpeg"];
    } else {
        Product* product = (Product*)selectedProduct;
        self.name.text = product.name;
        self.quantity.text = [Utilities formatAsDecimal:product.quantity];
        self.defaultPriceTextField.text = [Utilities formatAsCurrency:product.defaultCost];
        self.unitCostTextField.text = [Utilities formatAsCurrency:product.unitCost];
        self.productImageView.image = [[UIImage alloc] initWithData:product.image];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField.tag == UNIT_COST_TAG || textField.tag == DEFAULT_COST_TAG) {
       textField.text = [NSString stringWithFormat:@"$%@",textField.text];
    } 
    //
    // dismiss keyboard
    //
    [textField resignFirstResponder];
    [self.view removeGestureRecognizer:self.tap];
}

-(void)dismissKeyboard {
    [self.name resignFirstResponder];
    [self.quantity resignFirstResponder];
    //[self.view removeGestureRecognizer:self.tap];
}

-(void) viewDidAppear:(BOOL)animated {
}

- (void) viewWillAppear:(BOOL)animated  {
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

- (IBAction)resignButton:(id)sender {
    [self.name resignFirstResponder];
    [self.quantity resignFirstResponder];
}

- (IBAction)cancelProduct:(id)sender {
    [[State instance] clear];
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
    if([self.name.text isEqualToString:@""]) {
        
        //
        // alert the user that they need to select a product
        //
        NSString *message = @"Please enter a non-blank product name.";
        
        UIAlertView *alertDialog = [[UIAlertView alloc]
                                    initWithTitle:@"Blank product name"
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
        product.unitCost = [CURRENCY_FORMATTER numberFromString:self.unitCostTextField.text];
        product.defaultCost = [CURRENCY_FORMATTER numberFromString:self.defaultPriceTextField.text];
        product.image = UIImagePNGRepresentation(self.productImageView.image);
        product.retired = [NSNumber numberWithBool: NO];
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
    
    // begin scale image
    CGSize destinationSize = CGSizeMake(300, 300);
    
    UIGraphicsBeginImageContext(destinationSize);
    [productImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    self.productImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // end scale image
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


-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
