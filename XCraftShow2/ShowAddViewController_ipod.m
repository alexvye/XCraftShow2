//
//  ShowAddViewController_ipod.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowAddViewController_ipod.h"
#import "Show.h"
#import "Contact.h"
#import "Utilities.h"

@implementation ShowAddViewController_ipod

@synthesize showDate, showFee, showUrl, showName, showAddress, datePicker,managedObjectContext, selectedShow;

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
    
    if(selectedShow == nil) {
        self.showName.text = @"";
        self.showFee.text = [Utilities formatAsCurrency:[NSNumber numberWithInt:0]];
    } else {
        Show* show = (Show*)self.selectedShow;
        self.showName.text = show.name;
        self.showFee.text = [Utilities formatAsCurrency:[NSNumber numberWithInt:0]];
        Product* product = (Product*) self.selectedProduct;
        self.name.text = product.name;
        self.quantity.text = [Utilities formatAsDecimal:product.quantity];
        self.unitCost.text = [Utilities formatAsCurrency:product.unitCost];
        self.productDescription.text = product.productDescription;
        self.defaultCost.text = [Utilities formatAsCurrency:product.defaultCost];
    }
    
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

#pragma mark - buttons

-(IBAction) saveShow: (UIButton*) aButton {
    //
    // Create/set showinfo oject
    //
    Show* show = (Show*) [NSEntityDescription insertNewObjectForEntityForName:@"Show" inManagedObjectContext:self.managedObjectContext];
    show.name = self.showName.text;
    show.fee = [NSNumber numberWithInt:6];
    show.address = self.showAddress.text;
    show.rules = self.showUrl.text;
    show.date = self.datePicker.date;
    
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

- (IBAction)changeDateInLabel:(id)sender {
	//Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	NSLog(@"%@",[df stringFromDate:datePicker.date]);
}	


#pragma mark - textview delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    /*
     Project* project = [projects objectAtIndex:[DataManager getSelectedProject]];
     [project setName:[textField text]];
     [DataManager saveData];
     */
    [textField resignFirstResponder];
    return TRUE;
}

@end
