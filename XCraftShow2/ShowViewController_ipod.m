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
#import "Show.h"
#import "Utilities.h"
#import "State.h"

@interface ShowViewController_ipod ()

@end

@implementation ShowViewController_ipod

@synthesize datePicker, nameTextField, feeTextField, managedObjectContext;
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
        self.feeTextField.text = @"$0.00";
    } else {
        self.datePicker.date = self.passedShow.date;
        self.feeTextField.text = [Utilities formatAsCurrency:self.passedShow.fee];
        self.nameTextField.text = self.passedShow.name;
    }
    
	[self.datePicker addTarget:self
                        action:@selector(changeDateInLabel:)
              forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.datePicker];
}

- (void)viewWillAppear:(BOOL)animated {
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
}

- (IBAction)cancelShow:(id)sender {
    [[State instance] clear];
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
        show.fee = [CURRENCY_FORMATTER numberFromString:self.feeTextField.text];
                    
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.feeTextField.text = [NSString stringWithFormat:@"$%@",textField.text];

    //
    // dismiss keyboard
    //
    [textField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}
@end
