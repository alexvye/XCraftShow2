//
//  ProductPriceViewController.m
//  XCraftShow2
//
//  Created by Peter Chase on 12-07-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductPriceViewController.h"

@interface ProductPriceViewController ()

@end

@implementation ProductPriceViewController
@synthesize picker = _picker;
@synthesize price = _price;
@synthesize prevPriceLabel = _prevPriceLabel;

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
    if (self.prevPriceLabel != nil) {
        self.price = [self.prevPriceLabel titleForState:UIControlStateNormal];
    }
}


- (void)viewDidAppear:(BOOL)animated{
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
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    [self.prevPriceLabel setTitle:self.price forState:UIControlStateNormal] ;
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
    NSInteger dollarValue = [pickerView selectedRowInComponent:kDollars];
    NSInteger centValue = [pickerView selectedRowInComponent:KCents];
    self.price = [NSString stringWithFormat:@"$%d.%02d", dollarValue, centValue];
    NSLog(@"%@",self.price);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.prevPriceLabel setTitle:self.price forState:UIControlStateNormal] ;
    } else {
        [pickerView reloadComponent:kDollars];
    }
}

@end
