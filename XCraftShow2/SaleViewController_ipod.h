//
//  SaleViewController_ipod.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-14.
//
//

#import <UIKit/UIKit.h>
#import "Show.h"
#import "Sale.h"
#import "ProductTableViewController.h"

@interface SaleViewController_ipod : UIViewController <UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UIButton* priceButton;
    IBOutlet UITextField* quantity;
    IBOutlet UILabel* selectedProductLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* selectedProductLabel;
@property (strong, nonatomic) IBOutlet UIButton* priceButton;
@property(nonatomic, retain) IBOutlet UITextField* quantity;
@property(nonatomic, strong) IBOutlet UIPickerView* picker;
@property (strong, nonatomic) NSNumber* price;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Show *show;
@property (strong, nonatomic) Show *editedSale;
@property (strong, nonatomic) ProductTableViewController* prodView;
@property (strong, nonatomic) UITapGestureRecognizer *tap;


-(IBAction)selectProduct:(id)sender;
-(IBAction)saveSale:(id)sender;
-(IBAction)cancelSale:(id)sender;
-(IBAction)openPricePicker:(id)sender;
-(void)playSound;
-(IBAction)resignButton:(id)sender;

@end
