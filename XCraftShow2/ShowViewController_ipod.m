//
//  ShowViewController_ipod.m
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-27.
//
//
#define kDollars    0
#define KCents      1

#import "ShowViewController_ipod.h"
#import "Show.h"
#import "Utilities.h"

@interface ShowViewController_ipod ()

@end

@implementation ShowViewController_ipod

@synthesize datePicker, feeTextField, nameTextField, managedObjectContext, feePicker;

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
    datePicker.date = [NSDate date];
	[datePicker addTarget:self
                   action:@selector(changeDateInLabel:)
         forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:datePicker];
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

- (IBAction)cancelShow:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) saveShow: (UIButton*) aButton {
    //
    // Check existing product names for duplicates
    // product names is an array of strings
    //
    if([self.nameTextField.text isEqualToString:@""]) {
        
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
        Show* show = (Show*) [NSEntityDescription insertNewObjectForEntityForName:@"Show" inManagedObjectContext:self.managedObjectContext];

        show.name = self.nameTextField.text;
        show.date = self.datePicker.date;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        show.fee = [formatter numberFromString:self.feeTextField.text];
        
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
    //self.price = [NSString stringWithFormat:@"$%d.%02d", dollarValue, centValue];
    //    [pickerView reloadComponent:kDollars];
}

@end
