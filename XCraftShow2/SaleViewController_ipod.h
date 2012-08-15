//
//  SaleViewController_ipod.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-14.
//
//

#import <UIKit/UIKit.h>
#import "Show.h"

@interface SaleViewController_ipod : UIViewController {
    IBOutlet UITextField* price;
    IBOutlet UITextField* quantity;
}

@property(nonatomic, retain) Show* show;
@property (strong, nonatomic) NSManagedObject *selectedProduct;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet UITextField* price;
@property(nonatomic, retain) IBOutlet UITextField* quantity;


-(IBAction)selectProduct:(id)sender;
-(IBAction)saveSale:(id)sender;
-(IBAction)openPricePicker:(id)sender;
-(void)playSound;
-(IBAction)resignButton:(id)sender;

@end
