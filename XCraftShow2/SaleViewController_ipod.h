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

@interface SaleViewController_ipod : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField* quantity;
    IBOutlet UITextField* priceTextField;
    IBOutlet UILabel* selectedProductLabel;
    IBOutlet UIImageView*  productImage;
}

@property(nonatomic, retain) IBOutlet UILabel* selectedProductLabel;
@property(nonatomic, retain) IBOutlet UITextField* quantity;
@property(nonatomic, retain) IBOutlet UITextField* priceTextField;
@property (strong, nonatomic) IBOutlet UIImageView*  productImage;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Show *show;
@property (strong, nonatomic) Show *editedSale;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) ProductTableViewController* prodView;


-(IBAction)selectProduct:(id)sender;
-(IBAction)saveSale:(id)sender;
-(IBAction)cancelSale:(id)sender;
-(void)playSound;

@end
