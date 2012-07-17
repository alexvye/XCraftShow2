//
//  ProductAddViewController_ipod.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductAddViewController_ipod.h"
#import "Product.h"
#import "Utilities.h"

@implementation ProductAddViewController_ipod

@synthesize unitCost, productDescription, quantity, name, defaultCost;
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
        self.unitCost.text = [Utilities formatAsCurrency:[NSNumber numberWithInt:0]];
        self.productDescription.text = @"";
        self.defaultCost.text = [Utilities formatAsCurrency:[NSNumber numberWithInt:0]];
    } else {
        Product* product = (Product*) self.selectedProduct;
        self.name.text = product.name;
        self.quantity.text = [Utilities formatAsDecimal:product.quantity];
        self.unitCost.text = [Utilities formatAsCurrency:product.unitCost];
        self.productDescription.text = product.productDescription;
        self.defaultCost.text = [Utilities formatAsCurrency:product.defaultCost];
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

-(IBAction) saveProduct: (UIButton*) aButton {
    //
    // Create/set product oject
    //
    Product* product;
    
    //
    // Check existing product names for duplicates
    // product names is an array of strings
    //
    
    if(self.selectedProduct == nil && [self doesProductExist:self.name.text]) {
        //
        // alert the user that they need to select a product
        //
        NSString *message = @"Please enter a unique product name.";
        
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
        product.unitCost = [formatter numberFromString:self.unitCost.text];
        product.productDescription = self.productDescription.text;
        product.defaultCost = [formatter numberFromString:self.defaultCost.text];
        NSLog(@"[%@] [%@]",product.defaultCost,self.defaultCost.text);
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
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

#pragma mark - textfield/textview methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return TRUE;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

@end
