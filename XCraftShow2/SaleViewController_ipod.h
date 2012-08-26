//
//  SaleViewController_ipod.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-14.
//
//

#import <UIKit/UIKit.h>
#import "Show.h"

@interface SaleViewController_ipod : UIViewController <UITextFieldDelegate> {
    IBOutlet UIButton* price;
    IBOutlet UITextField* quantity;
    IBOutlet UILabel* selectedProductLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* selectedProductLabel;
@property (strong, nonatomic) IBOutlet UIButton* price;
@property(nonatomic, retain) IBOutlet UITextField* quantity;
@property(nonatomic, retain) NSString* eventId;
@property (strong, nonatomic) NSManagedObject *selectedProduct;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


-(IBAction)selectProduct:(id)sender;
-(IBAction)saveSale:(id)sender;
-(IBAction)openPricePicker:(id)sender;
-(void)playSound;
-(IBAction)resignButton:(id)sender;

@end
