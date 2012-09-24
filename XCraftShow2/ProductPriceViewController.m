//
//  ProductPriceViewController.m
//  XCraftShow2
//
//  Created by Peter Chase on 12-07-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductPriceViewController.h"
#import "State.h"

@interface ProductPriceViewController ()

@end

@implementation ProductPriceViewController
@synthesize picker = _picker;
@synthesize priceKey;
@synthesize price;

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
}


- (void)viewDidAppear:(BOOL)animated{
    
    self.price = [[State instance].mem objectForKey:self.priceKey];
    if (self.price != nil) {
        int dollar = self.price.intValue;
        int cent = (self.price.doubleValue - dollar)*100;
            
        [self.picker selectRow:dollar inComponent:0 animated:NO];
        [self.picker reloadComponent:0];
        [self.picker selectRow:cent inComponent:1 animated:NO];
        [self.picker reloadComponent:1];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
            return [NSString stringWithFormat:@"   %d", row];
    }

    return [NSString stringWithFormat:@"%02d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSNumber* dollarValue = [NSNumber numberWithInt:[pickerView selectedRowInComponent:kDollars]];
    NSNumber* centValue = [NSNumber numberWithInt:[pickerView selectedRowInComponent:KCents]];
    self.price = [NSNumber numberWithDouble:dollarValue.doubleValue + centValue.doubleValue/100];
    [[State instance].mem setValue:self.price forKey:self.priceKey];
}

@end
