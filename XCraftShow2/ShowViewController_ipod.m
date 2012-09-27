//
//  ShowViewController_ipod.m
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-27.
//
//
#define kDollars    0
#define KCents      1

#define FEE_BUTTON 2
#define SAVE_BUTTON 1

#import "ShowViewController_ipod.h"
#import "ProductPriceViewController.h"
#import "Show.h"
#import "Utilities.h"
#import "State.h"

@interface ShowViewController_ipod ()

@end

@implementation ShowViewController_ipod

@synthesize datePicker, feeButton, nameTextField, managedObjectContext;
@synthesize passedShow;

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
    // Do any additional setup after loading the view from its nib
    if(self.passedShow == nil) {
        self.datePicker.date = [NSDate date];
    }
    
	[self.datePicker addTarget:self
                        action:@selector(changeDateInLabel:)
              forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.datePicker];
}

- (void)viewWillAppear:(BOOL)animated {


    //
    // if a show passed in, use it
    //
    if(self.passedShow != nil) {
        self.datePicker.date = self.passedShow.date;
        [self.feeButton setTitle:[Utilities formatAsCurrency:self.passedShow.fee] forState:UIControlStateNormal];
        self.nameTextField.text = self.passedShow.name;
    }
    
    //
    // If coming back from price picker
    //
    if([State instance].showName != nil) {
        self.nameTextField.text = [State instance].showName;
    }
    
    if([State instance].showDate != nil) {
        self.datePicker.date = [State instance].showDate;
    }
    NSNumber* showFee = [State instance].showFee;
    if(showFee.doubleValue!=0.00)  {
        [self.feeButton setTitle:[Utilities formatAsCurrency:showFee] forState:UIControlStateNormal];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)changeDateInLabel:(id)sender{
	//Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	NSString* message = [NSString stringWithFormat:@"%@",
                  [df stringFromDate:datePicker.date]];
	NSLog(@"%@",message);
}

- (IBAction)changeFee:(id)sender {
    //
    // Save show first
    //[

    [State instance].showName = self.nameTextField.text;
    [State instance].showDate = self.datePicker.date;
    
    //
    // Now pick fee
    //
    ProductPriceViewController* ppvc = [[ProductPriceViewController alloc] initWithNibName:@"ProductPriceViewController" bundle:nil];
    ppvc.priceKey  = SHOW_FEE;
    [self presentModalViewController:ppvc animated:YES];
}

- (IBAction)cancelShow:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) saveShow: (UIButton*) aButton {
    //
    // Check existing product names for duplicates
    // product names is an array of strings
    //
    if([self.nameTextField.text isEqualToString:@""] && aButton != nil) {
        
        //
        // alert the user that they need to select a product
        //
        NSString *message = @"Please enter a non-blank show name.";
        
        UIAlertView *alertDialog = [[UIAlertView alloc]
                                    initWithTitle:@"Blank show name"
                                    message:message
                                    delegate:nil
                                    cancelButtonTitle:@"Ok"
                                    otherButtonTitles:nil];
        [alertDialog show];
    } else {
        Show* show;
        if(self.passedShow == nil) {
            show = (Show*) [NSEntityDescription insertNewObjectForEntityForName:@"Show" inManagedObjectContext:self.managedObjectContext];
        } else {
            show = self.passedShow;
        }

        show.name = self.nameTextField.text;
        show.date = self.datePicker.date;

        show.fee = [State instance].showFee;
                    
        //
        // Save
        //
        NSError *error;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Error %@", [error localizedDescription]);
        }
        
        //
        // Pop view (if the passed button was not nil ...i.e. we are saving from a button
        // press
        //
        [[State instance] clear];
        if(aButton != nil) {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}
@end
