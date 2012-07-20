//
//  ProductPriceViewControllerViewController.h
//  XCraftShow2
//
//  Created by Peter Chase on 12-07-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDollars    0
#define KCents      1

@interface ProductPriceViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) IBOutlet UIPickerView* picker;
@property(nonatomic, strong) IBOutlet UILabel* priceLabel;
@property(nonatomic, strong) UIButton* prevPriceLabel;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
